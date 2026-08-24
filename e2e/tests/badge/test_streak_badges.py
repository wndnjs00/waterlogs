"""
TC-BADGE-02 / 03 / 04: streak 연속 뱃지.

UI로는 N일을 기다릴 수 없으므로 Admin SDK로 users/{uid} 를 시드한 뒤
앱에서 오늘 목표 달성·저장 → 뱃지 확인.

시드 필드 (앱 water_repository_impl 기준):
  streakDays = N-1
  lastGoalAchievedDate = 어제 (yyyy-MM-dd)
  goalAchievedDate 삭제 → 오늘 최초 목표 달성

필요: e2e/.env 의 E2E_FIREBASE_CREDENTIALS
"""

import time

import pytest
from selenium.common.exceptions import TimeoutException

from config.firestore_seed import (
    assert_badge_acquired_in_firestore,
    require_firestore_admin,
    seed_streak_before_goal,
    uid_by_email,
)
from pages.badge_page import (
    KING_6M_NAME,
    MONTH_30_NAME,
    WEEK_7_NAME,
    BadgePage,
)
from pages.main_page import MainPage
from pages.water_helpers import sign_up_to_water

_PASSWORD = "ValidPass1!"


def _open_badges(driver) -> BadgePage:
    """뱃지 아이콘 탭 → 화면 진입 (최대 3회 재시도)."""
    main = MainPage(driver)
    last_err = None
    for _ in range(3):
        # 메인 위에 이상한 다이얼로그가 있으면 닫기
        if "물 한 잔 마셨나요?" not in driver.page_source:
            if "새로운 뱃지 획득" not in driver.page_source:
                try:
                    driver.back()
                    time.sleep(0.5)
                except Exception:
                    pass

        main.wait_until_loaded()
        main.tap_badge()
        page = BadgePage(driver)
        try:
            page.wait_until_loaded()
            return page
        except TimeoutException as e:
            last_err = e
            time.sleep(1.0)

    raise TimeoutException(
        f"뱃지 화면 진입 실패: {last_err}",
        None,
        None,
    )


def _sign_up_seed_reach_goal_and_assert(
    driver,
    *,
    email_prefix: str,
    streak_before: int,
    badge_id: str,
    badge_name: str,
):
    require_firestore_admin()

    email = f"{email_prefix}_{int(time.time())}@test.com"
    water = sign_up_to_water(driver, email, _PASSWORD)

    uid = uid_by_email(email)
    seed_streak_before_goal(uid, streak_days=streak_before)

    # 시드가 Firestore 트랜잭션에 반영될 여유
    time.sleep(1.5)

    water.reach_goal_and_save()

    # Firestore 문서 (TC 기대결과) — 스트림 지연 대비 재시도
    data = None
    last_assert_err = None
    for _ in range(8):
        try:
            data = assert_badge_acquired_in_firestore(uid, badge_id)
            break
        except AssertionError as e:
            last_assert_err = e
            time.sleep(1.0)
    if data is None:
        raise last_assert_err
    assert data.get("name") == badge_name

    # UI: 다이얼로그/그리드에서 뱃지 이름 확인
    badge = _open_badges(driver)
    badge.assert_badge_name_visible(badge_name)


@pytest.mark.streak_badge
def test_week_7days_badge_with_firestore_seed(driver):
    """
    TC-BADGE-02: streakDays=6 + 어제 목표일 시드 → 오늘 8잔 저장 → week_7days.
    """
    _sign_up_seed_reach_goal_and_assert(
        driver,
        email_prefix="waterlog_e2e_streak7",
        streak_before=6,
        badge_id="week_7days",
        badge_name=WEEK_7_NAME,
    )


@pytest.mark.streak_badge
def test_month_30days_badge_with_firestore_seed(driver):
    """
    TC-BADGE-03: streakDays=29 시드 → month_30days.
    """
    _sign_up_seed_reach_goal_and_assert(
        driver,
        email_prefix="waterlog_e2e_streak30",
        streak_before=29,
        badge_id="month_30days",
        badge_name=MONTH_30_NAME,
    )


@pytest.mark.streak_badge
def test_king_6months_badge_with_firestore_seed(driver):
    """
    TC-BADGE-04: streakDays=179 시드 → king_6months.
    """
    _sign_up_seed_reach_goal_and_assert(
        driver,
        email_prefix="waterlog_e2e_streak180",
        streak_before=179,
        badge_id="king_6months",
        badge_name=KING_6M_NAME,
    )
