"""가입 후 메인 진입을 보장하는 공통 헬퍼."""

from pages.login_page import LoginPage
from pages.main_page import MainPage
from pages.sign_up_page import SignUpPage, _has_accessibility_id


def sign_up_and_reach_main(driver, email: str, password: str) -> MainPage:
    """
    회원가입 후 메인(WaterLog)까지 이동.
    가입 직후 로그인 홈에 남으면 같은 계정으로 로그인해 메인을 연다.
    """
    SignUpPage(driver).sign_up_with_email(email, password)

    if _has_accessibility_id(driver, "WaterLog"):
        main = MainPage(driver)
        main.wait_until_loaded()
        return main

    LoginPage(driver).login_with_email(email, password)
    main = MainPage(driver)
    main.wait_until_loaded()
    return main
