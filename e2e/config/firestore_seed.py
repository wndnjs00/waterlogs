"""
E2E용 Firestore Admin 시드.

앱 saveWithAchievement 는 users/{uid} 의 다음 필드를 본다
(water_repository_impl.dart):
  - streakDays
  - lastGoalAchievedDate  (어제면 streak+1)
  - goalAchievedDate      (오늘이면 목표 알림/뱃지 재생성 안 함)

필요 환경변수:
  E2E_FIREBASE_CREDENTIALS=/절대경로/serviceAccount.json
  (또는 GOOGLE_APPLICATION_CREDENTIALS)
"""

from __future__ import annotations

import os
from datetime import date, timedelta
from functools import lru_cache
from typing import Optional

import pytest

_PROJECT_ID = "waterlog-f7fc7"


def _credentials_path() -> Optional[str]:
    return (
        os.getenv("E2E_FIREBASE_CREDENTIALS")
        or os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
    )


@lru_cache(maxsize=1)
def _init_app():
    path = _credentials_path()
    if not path:
        pytest.skip(
            "Firestore 시드용 서비스 계정이 없습니다. "
            "e2e/.env 에 E2E_FIREBASE_CREDENTIALS=/path/to/serviceAccount.json 을 설정하세요."
        )
    if not os.path.isfile(path):
        pytest.skip(f"서비스 계정 파일이 없습니다: {path}")

    import firebase_admin
    from firebase_admin import credentials

    if not firebase_admin._apps:
        cred = credentials.Certificate(path)
        firebase_admin.initialize_app(cred, {"projectId": _PROJECT_ID})
    return firebase_admin.get_app()


def require_firestore_admin():
    """테스트에서 시드 전에 호출 — 미설정 시 skip."""
    _init_app()


def today_iso() -> str:
    return date.today().isoformat()  # yyyy-MM-dd


def yesterday_iso() -> str:
    return (date.today() - timedelta(days=1)).isoformat()


def uid_by_email(email: str) -> str:
    _init_app()
    from firebase_admin import auth

    return auth.get_user_by_email(email).uid


def seed_streak_before_goal(
    uid: str,
    *,
    streak_days: int,
    last_goal_date: Optional[str] = None,
) -> None:
    """
    오늘 목표 달성 저장 시 streak 가 (streak_days + 1) 이 되도록 시드.

    - lastGoalAchievedDate = 어제 → StreakCalculator 가 currentStreak + 1
    - goalAchievedDate 제거 → 오늘 최초 목표 달성으로 취급
    """
    _init_app()
    from firebase_admin import firestore

    db = firestore.client()
    yesterday = last_goal_date or yesterday_iso()

    db.collection("users").document(uid).set(
        {
            "streakDays": streak_days,
            "lastGoalAchievedDate": yesterday,
            "goalAchievedDate": firestore.DELETE_FIELD,
        },
        merge=True,
    )


def assert_badge_acquired_in_firestore(uid: str, badge_id: str) -> dict:
    """users/{uid}/badges/{badge_id} acquired:true 확인."""
    _init_app()
    from firebase_admin import firestore

    db = firestore.client()
    snap = (
        db.collection("users")
        .document(uid)
        .collection("badges")
        .document(badge_id)
        .get()
    )
    assert snap.exists, f"뱃지 문서 없음: users/{uid}/badges/{badge_id}"
    data = snap.to_dict() or {}
    assert data.get("acquired") is True, f"acquired != true: {data}"
    return data


def _notifications_col(uid: str):
    from firebase_admin import firestore

    return (
        firestore.client()
        .collection("users")
        .document(uid)
        .collection("notifications")
    )


def clear_today_goal_for_notification_test(uid: str) -> None:
    """
    기존 계정으로 TC-NOTI-04 재현용.
    - goalAchievedDate 제거 → 오늘 다시 목표 알림 생성 가능
    - type=goal_achieved 알림 문서 삭제 → 개수 assert 가 깨끗함
    """
    _init_app()
    from firebase_admin import firestore

    db = firestore.client()
    db.collection("users").document(uid).set(
        {"goalAchievedDate": firestore.DELETE_FIELD},
        merge=True,
    )

    col = _notifications_col(uid)
    for doc in col.where("type", "==", "goal_achieved").stream():
        doc.reference.delete()


def ensure_unread_notification(uid: str) -> str:
    """
    미읽음 알림 1건 보장 (목록 최상단이 되도록 createdAt 을 최신으로).
    Returns: notification doc id
    """
    _init_app()
    from datetime import datetime

    col = _notifications_col(uid)
    title = "E2E 미읽음 알림"
    now = datetime.now().strftime("%Y/%m/%d %H:%M:%S")

    for doc in col.where("title", "==", title).stream():
        doc.reference.update({"isRead": False, "createdAt": now})
        return doc.id

    _, ref = col.add(
        {
            "title": title,
            "message": "읽음 처리 테스트용",
            "type": "welcome",
            "createdAt": now,
            "isRead": False,
        }
    )
    return ref.id


def get_notification(uid: str, noti_id: str) -> dict:
    _init_app()
    snap = _notifications_col(uid).document(noti_id).get()
    assert snap.exists, f"알림 없음: {noti_id}"
    return snap.to_dict() or {}


def count_notifications_by_type(uid: str, noti_type: str) -> int:
    _init_app()
    return len(list(_notifications_col(uid).where("type", "==", noti_type).stream()))
