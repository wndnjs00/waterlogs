"""
TC-ERR-01: 네트워크 오류 메시지.

앱 AuthErrorMapper: 네트워크 예외 → `네트워크 연결 상태가 좋지 않습니다`
(스낵바/토스트)

절차: adb 로 Wi‑Fi·데이터 OFF → 로그인 또는 물 저장 시도 → 메시지 확인 → 네트워크 복구
"""

import time

import pytest

from config.network_control import NetworkControl
from pages.login_page import LoginPage
from pages.water_helpers import login_to_water

NETWORK_ERROR_MSG = "네트워크 연결 상태가 좋지 않습니다"


def _wait_network_error(driver, timeout: float = 45):
    """SnackBar 문구가 page_source / content-desc 에 나타날 때까지."""
    end = time.time() + timeout
    while time.time() < end:
        if NETWORK_ERROR_MSG in driver.page_source:
            return
        time.sleep(0.5)
    raise AssertionError(
        f"네트워크 오류 메시지가 나타나지 않음: '{NETWORK_ERROR_MSG}'"
    )


@pytest.mark.network_error
def test_network_error_on_email_login(driver, e2e_credentials):
    """
    TC-ERR-01 (로그인):
      네트워크 OFF → 이메일 로그인 시도 → 스낵바 메시지.
    """
    email, password = e2e_credentials
    net = NetworkControl(driver)

    try:
        # 로그인 화면까지는 온라인으로 앱만 기동된 상태 (세션 시작)
        login = LoginPage(driver)
        login.wait_for_login_home()

        net.go_offline()

        login.open_email_sign_in()
        login.wait_for_sign_in_form()
        login.enter_email(email)
        login.enter_password(password)
        login.tap_login_submit()

        _wait_network_error(driver)
        login.wait_for_auth_error(NETWORK_ERROR_MSG, timeout=5)
    finally:
        net.go_online()


@pytest.mark.network_error
def test_network_error_on_water_save(driver, e2e_credentials):
    """
    TC-ERR-01 (저장):
      로그인(온라인) → 네트워크 OFF → +/- 후 저장 → 스낵바 메시지.
    """
    net = NetworkControl(driver)

    try:
        water = login_to_water(driver, e2e_credentials)

        net.go_offline()

        # 저장이 가능하도록 미저장 변경 만들기
        before = water.read_status()
        if before[0] == "goal":
            water.tap_minus()
            water.wait_status_changed(before)
        else:
            water.tap_plus()
            try:
                water.wait_status_changed(before, timeout=5)
            except AssertionError:
                pass

        water.tap_save()
        _wait_network_error(driver, timeout=45)
    finally:
        net.go_online()
