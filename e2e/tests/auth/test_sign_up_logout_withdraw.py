import time

from pages.auth_helpers import sign_up_and_reach_main
from pages.login_page import LoginPage
from pages.sign_up_page import _has_accessibility_id

# 앱 비밀번호 규칙: 8자 이상 + 영문 + 숫자 + 특수문자
_PASSWORD = "ValidPass1!"


def test_sign_up_then_logout(driver):
    """TC-AUTH-07: 회원가입 → 메인 → 로그아웃 → 로그인 홈."""
    email = f"waterlog_e2e_logout_{int(time.time())}@test.com"

    main = sign_up_and_reach_main(driver, email, _PASSWORD)
    assert main.is_loaded()

    main.logout()

    # 로그인 홈으로 왔는지 확인 (이게 통과해야 PASSED)
    LoginPage(driver).wait_for_login_home()
    assert _has_accessibility_id(driver, "워터로그")
    # 메인 AppBar는 더 이상 없어야 함
    assert not _has_accessibility_id(driver, "WaterLog")
    assert driver.current_package == "com.juwon.waterlog"


def test_sign_up_then_withdraw(driver):
    """TC-AUTH-08-B: 회원가입 → 메인 → 회원탈퇴(비밀번호 재인증) → 로그인 홈."""
    email = f"waterlog_e2e_withdraw_{int(time.time())}@test.com"

    main = sign_up_and_reach_main(driver, email, _PASSWORD)
    assert main.is_loaded()

    main.withdraw_with_email_password(_PASSWORD)

    LoginPage(driver, timeout=40).wait_for_login_home()
    assert _has_accessibility_id(driver, "워터로그")
    assert not _has_accessibility_id(driver, "WaterLog")
    assert driver.current_package == "com.juwon.waterlog"
