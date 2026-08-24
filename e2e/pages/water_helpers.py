"""가입 후 WaterPage까지."""

from pages.auth_helpers import sign_up_and_reach_main
from pages.login_page import LoginPage
from pages.main_page import MainPage
from pages.water_page import WaterPage


def login_to_water(driver, e2e_credentials) -> WaterPage:
    email, password = e2e_credentials
    LoginPage(driver).login_with_email(email, password)
    MainPage(driver).wait_until_loaded()
    water = WaterPage(driver)
    water.wait_until_ready()
    return water


def sign_up_to_water(driver, email: str, password: str) -> WaterPage:
    """신규 가입 계정으로 메인 물 화면까지 (목표/뱃지 미달 상태)."""
    sign_up_and_reach_main(driver, email, password)
    water = WaterPage(driver)
    water.wait_until_ready()
    return water
