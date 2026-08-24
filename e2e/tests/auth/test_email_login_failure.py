"""TC-AUTH-05 / TC-AUTH-06: 이메일 로그인 실패."""

import time

from pages.login_page import LoginPage
from pages.main_page import MainPage


def test_email_login_wrong_password(driver, e2e_credentials):
    """
    TC-AUTH-05: 올바른 이메일 + 잘못된 비밀번호.
    기대: AuthErrorMapper → '잘못된 계정입니다'
    (비밀번호는 형식은 유효해야 '로그인 하기'가 활성화됨)
    """
    email, _correct_password = e2e_credentials
    # 형식은 유효해야 버튼 활성화 (! 대신 @ — 일부 환경에서 특수문자 입력 이슈 완화)
    wrong_password = "WrongPass1@"

    login = LoginPage(driver)
    login.open_sign_in_form()
    login.enter_email(email)
    login.enter_password(wrong_password)
    login.tap_login_submit()

    login.wait_for_auth_error("잘못된 계정입니다")
    # 메인으로 가지 않았는지
    assert not MainPage(driver).is_loaded()


def test_email_login_unregistered_account(driver):
    """
    TC-AUTH-06: 미가입 이메일로 로그인.
    기대: '가입 안된 계정' 또는 Firebase 열거 방지 시 '잘못된 계정입니다'
    """
    email = f"never_registered_{int(time.time())}@test.com"
    password = "ValidPass1@"

    login = LoginPage(driver)
    login.open_sign_in_form()
    login.enter_email(email)
    login.enter_password(password)
    login.tap_login_submit()

    login.wait_for_auth_error("가입 안된 계정", "잘못된 계정입니다")
    assert not MainPage(driver).is_loaded()
