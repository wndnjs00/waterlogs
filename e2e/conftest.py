import os
from pathlib import Path

import pytest
from appium import webdriver
from appium.options.android import UiAutomator2Options
from dotenv import load_dotenv

from config.capabilities import ANDROID_CAPS

load_dotenv(Path(__file__).resolve().parent / ".env")

APPIUM_SERVER = "http://127.0.0.1:4723"


@pytest.fixture
def driver():
    options = UiAutomator2Options().load_capabilities(ANDROID_CAPS)
    drv = webdriver.Remote(APPIUM_SERVER, options=options)
    yield drv
    drv.quit()


@pytest.fixture
def e2e_credentials():
    email = os.getenv("E2E_EMAIL")
    password = os.getenv("E2E_PASSWORD")
    if not email or not password:
        pytest.skip("e2e/.env 에 E2E_EMAIL / E2E_PASSWORD 를 설정하세요")
    return email, password
