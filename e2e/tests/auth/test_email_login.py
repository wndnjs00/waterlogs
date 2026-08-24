from pages.login_page import LoginPage
from pages.main_page import MainPage


def test_email_login_success(driver, e2e_credentials):
    """TC-AUTH-04: 이메일 로그인 성공 → 메인(WaterLog) 진입."""
    email, password = e2e_credentials

    login = LoginPage(driver)                   # 로그인 화면용 리모컨 매뉴얼
    login.login_with_email(email, password)     # 로그인 전체 과정 한 번에

    main = MainPage(driver)                    # 메인 화면용 매뉴얼
    main.wait_until_loaded()                   # WaterLog 뜰 때까지 기다림

    assert main.is_loaded()                                 # WaterLog 뜨면 True
    assert driver.current_package == "com.juwon.waterlog"   # WaterLog 패키지 이름 확인 / assert가 둘다 참이면 PASSED
