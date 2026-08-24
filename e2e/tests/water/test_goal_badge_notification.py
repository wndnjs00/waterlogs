"""
TC-BADGE-01 + TC-NOTI-04 통합 (기존 E2E 계정).

목표 최초 달성 저장 시 알림 + day_2L 뱃지를 한 시나리오에서 검증.
신규 가입 없이 Firestore로 당일 목표 상태만 리셋한다.
"""

import time

from config.firestore_seed import (
    assert_badge_acquired_in_firestore,
    clear_today_goal_for_notification_test,
    require_firestore_admin,
    uid_by_email,
)
from pages.badge_page import DAY_2L_NAME, BadgePage
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


def _open_badges(driver) -> BadgePage:
    MainPage(driver).tap_badge()
    page = BadgePage(driver)
    page.wait_until_loaded()
    page.dismiss_all_earned_dialogs()
    return page


def test_goal_save_creates_notification_and_day2l_badge(driver, e2e_credentials):
    """
    TC-NOTI-04 + TC-BADGE-01 (동시):
      목표 직전 → + → 저장
      → 알림: 오늘 물섭취 목표 달성
      → 뱃지: 하루 2L 달성 (이미 있어도 UI/문서에 존재)
    """
    require_firestore_admin()
    email, _ = e2e_credentials
    uid = uid_by_email(email)
    clear_today_goal_for_notification_test(uid)

    water = login_to_water(driver, e2e_credentials)
    time.sleep(1.0)
    water.reach_goal_and_save()

    noti = _open_notifications(driver)
    noti.assert_goal_achieved_present()
    assert noti.count_goal_achieved() >= 1
    assert GOAL_NOTI_MESSAGE in driver.page_source
    noti.go_back()

    MainPage(driver).wait_until_loaded()

    # Firestore day_2L (이미 있어도 acquired true)
    data = assert_badge_acquired_in_firestore(uid, "day_2L")
    assert data.get("name") == DAY_2L_NAME

    badge = _open_badges(driver)
    badge.assert_day_2l_acquired()
