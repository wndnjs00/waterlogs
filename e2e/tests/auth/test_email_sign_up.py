import time

from pages.sign_up_page import SignUpPage, _has_accessibility_id

# 앱 비밀번호 규칙: 8자 이상 + 영문 + 숫자 + 특수문자
_SIGN_UP_PASSWORD = "ValidPass1!"


def test_email_sign_up_success(driver):
    """TC-AUTH-02: 이메일 회원가입 성공 → 로그인 홈 또는 메인 진입."""
    email = f"waterlog_e2e_{int(time.time())}@test.com"

    SignUpPage(driver).sign_up_with_email(email, _SIGN_UP_PASSWORD)

    on_login_home = _has_accessibility_id(driver, "워터로그")
    on_main = _has_accessibility_id(driver, "WaterLog")
    assert on_login_home or on_main, "가입 후 로그인 홈/메인 중 하나가 보여야 함"
    assert driver.current_package == "com.juwon.waterlog"
