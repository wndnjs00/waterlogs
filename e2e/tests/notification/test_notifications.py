"""
TC-NOTI-02 / 03 / 04 / 05 — 기존 E2E 계정 사용 (신규 가입 최소화).

- NOTI-03: 가입 시 만든 welcome 이 목록에 있는지
- NOTI-02: 미읽음 탭 → Firestore isRead=true
- NOTI-04: goalAchievedDate 리셋 + goal_achieved 삭제 후 목표 저장 → 알림 1건
- NOTI-05: 재달성 저장해도 goal_achieved 추가 없음
"""

import time

from config.firestore_seed import (
    clear_today_goal_for_notification_test,
    count_notifications_by_type,
    ensure_unread_notification,
    get_notification,
    require_firestore_admin,
    uid_by_email,
)
from pages.main_page import MainPage
from pages.notification_page import (
    GOAL_NOTI_MESSAGE,
    NotificationPage,
)
from pages.water_helpers import login_to_water


def _open_notifications(driver) -> NotificationPage:
    MainPage(driver).tap_notifications()
    page = NotificationPage(driver)
    page.wait_until_loaded()
    return page


def test_welcome_notification_present(driver, e2e_credentials):
    """
    TC-NOTI-03: 기존 계정에 welcome 알림이 있다.
    (최초 가입 때 생성된 알림 — 추가 회원가입 없음)
    """
    login_to_water(driver, e2e_credentials)
    noti = _open_notifications(driver)
    noti.assert_welcome_present()


def test_mark_notification_as_read(driver, e2e_credentials):
    """
    TC-NOTI-02: 미읽음 알림 탭 → isRead=true (Firestore로 확인).
    로그인 후 시드해 스트림이 새 알림을 받도록 한다.
    """
    require_firestore_admin()
    email, _ = e2e_credentials
    uid = uid_by_email(email)

    login_to_water(driver, e2e_credentials)

    noti_id = ensure_unread_notification(uid)
    assert get_notification(uid, noti_id).get("isRead") is False
    # 메인에서 Firestore 스냅샷 반영 대기
    time.sleep(2.0)

    noti = _open_notifications(driver)
    noti.tap_notification_by_title("E2E 미읽음 알림")

    deadline = time.time() + 20
    while time.time() < deadline:
        if get_notification(uid, noti_id).get("isRead") is True:
            break
        # 한 번 더 탭 시도
        try:
            noti.tap_notification_by_title("E2E 미읽음 알림")
        except Exception:
            pass
        time.sleep(1.0)

    assert get_notification(uid, noti_id).get("isRead") is True


def test_goal_achieved_notification_created(driver, e2e_credentials):
    """
    TC-NOTI-04: 오늘 최초 목표 달성 저장 → goal_achieved 알림.
    기존 계정: Firestore로 당일 목표 상태/기존 goal 알림을 리셋한 뒤 검증.
    """
    require_firestore_admin()
    email, _ = e2e_credentials
    uid = uid_by_email(email)

    clear_today_goal_for_notification_test(uid)
    assert count_notifications_by_type(uid, "goal_achieved") == 0

    water = login_to_water(driver, e2e_credentials)
    # 앱이 오래된 goalAchievedDate 캐시를 쓰지 않도록, 저장은 Firestore 트랜잭션 기준
    water.ensure_remaining(1)
    before = water.read_status()
    water.tap_plus()
    after = water.wait_status_changed(before)
    assert after[0] == "goal"
    water.tap_save()
    water.wait_save_finished()

    noti = _open_notifications(driver)
    noti.assert_goal_achieved_present()
    assert noti.count_goal_achieved() == 1
    assert GOAL_NOTI_MESSAGE in driver.page_source

    # Firestore type 카운트도 1
    deadline = time.time() + 15
    while time.time() < deadline:
        if count_notifications_by_type(uid, "goal_achieved") == 1:
            break
        time.sleep(0.5)
    assert count_notifications_by_type(uid, "goal_achieved") == 1


def test_goal_achieved_notification_not_duplicated(driver, e2e_credentials):
    """
    TC-NOTI-05: 당일 목표 알림은 최초 1회만.
    전제: 이미 오늘 목표 달성·알림 1건 (없으면 NOTI-04와 같이 준비).
    """
    require_firestore_admin()
    email, _ = e2e_credentials
    uid = uid_by_email(email)

    water = login_to_water(driver, e2e_credentials)

    # 목표 알림 1건 보장
    if count_notifications_by_type(uid, "goal_achieved") == 0:
        clear_today_goal_for_notification_test(uid)
        water.reach_goal_and_save()
        deadline = time.time() + 20
        while time.time() < deadline:
            if count_notifications_by_type(uid, "goal_achieved") >= 1:
                break
            time.sleep(0.5)

    first_fs = count_notifications_by_type(uid, "goal_achieved")
    assert first_fs >= 1

    # UI 상 목표 상태 보장 후 −/+ 재달성·저장
    kind, _ = water.read_status()
    if kind != "goal":
        water.ensure_remaining(1)
        before = water.read_status()
        water.tap_plus()
        water.wait_status_changed(before)
        water.tap_save()
        water.wait_save_finished()
        first_fs = count_notifications_by_type(uid, "goal_achieved")

    before = water.read_status()
    assert before[0] == "goal"
    water.tap_minus()
    water.wait_status_changed(before)
    assert water.read_status() == ("remaining", 1)

    before2 = water.read_status()
    water.tap_plus()
    water.wait_status_changed(before2)
    assert water.read_status()[0] == "goal"

    water.tap_save()
    water.wait_save_finished()
    time.sleep(1.5)

    second_fs = count_notifications_by_type(uid, "goal_achieved")
    assert second_fs == first_fs

    noti = _open_notifications(driver)
    noti.wait_for_goal_achieved()
    # 같은 제목이 여러 번이면 중복 생성
    assert noti.count_goal_achieved() == first_fs
