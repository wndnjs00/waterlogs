from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from pages.login_page import LoginPage


def _has_accessibility_id(driver, desc: str) -> bool:
    try:
        driver.find_element(AppiumBy.ACCESSIBILITY_ID, desc)
        return True
    except Exception:
        return False


class SignUpPage:
    """SignUpScreen 이메일 회원가입 플로우 (sign_up_screen.dart)."""

    def __init__(self, driver, timeout: int = 25):
        self.driver = driver
        self.wait = WebDriverWait(driver, timeout)
        self.login = LoginPage(driver, timeout=timeout)

    def _by_desc(self, desc: str):
        return (AppiumBy.ACCESSIBILITY_ID, desc)

    def _edit_text(self, index: int):
        # 이메일=0, 비밀번호=1, 비밀번호 확인=2
        return (
            AppiumBy.ANDROID_UIAUTOMATOR,
            f'new UiSelector().className("android.widget.EditText").instance({index})',
        )

    def _hide_keyboard(self):
        try:
            self.driver.hide_keyboard()
        except Exception:
            pass

    def wait_for_sign_up_form(self):
        self.wait.until(
            EC.presence_of_element_located(self._by_desc("이메일로 회원가입"))
        )
        self.wait.until(EC.presence_of_element_located(self._edit_text(0)))

    def enter_email(self, email: str):
        element = self.wait.until(
            EC.presence_of_element_located(self._edit_text(0))
        )
        element.click()
        element.clear()
        element.send_keys(email)

    def enter_password(self, password: str):
        element = self.wait.until(
            EC.presence_of_element_located(self._edit_text(1))
        )
        element.click()
        element.clear()
        element.send_keys(password)

    def enter_confirm_password(self, password: str):
        element = self.wait.until(
            EC.presence_of_element_located(self._edit_text(2))
        )
        element.click()
        element.clear()
        element.send_keys(password)

    def open_sign_up_form(self):
        """로그인 홈 → 회원가입 화면만 연다 (제출하지 않음)."""
        self.login.wait_for_login_home()
        self.login.open_email_sign_up()
        self.wait_for_sign_up_form()

    def wait_for_message(self, message: str, timeout: int = 10):
        WebDriverWait(self.driver, timeout).until(
            EC.presence_of_element_located(self._by_desc(message))
        )

    def is_sign_up_submit_enabled(self) -> bool:
        self._hide_keyboard()
        element = self.wait.until(
            EC.presence_of_element_located(self._by_desc("가입하기"))
        )
        return element.get_attribute("enabled") == "true"

    def accept_terms(self):
        self._hide_keyboard()
        checkbox = self.wait.until(
            EC.element_to_be_clickable(
                (
                    AppiumBy.ANDROID_UIAUTOMATOR,
                    'new UiSelector().className("android.widget.CheckBox")',
                )
            )
        )
        if checkbox.get_attribute("checked") != "true":
            checkbox.click()

    def tap_sign_up_submit(self):
        self._hide_keyboard()
        element = self.wait.until(
            EC.element_to_be_clickable(self._by_desc("가입하기"))
        )
        element.click()

    def wait_until_signed_up(self, timeout: int = 40):
        """
        가입 성공 후 도착 화면:
        - 로그인 홈: content-desc '워터로그'
        - 또는 user 상태가 이미 있어 메인으로 간 경우: 'WaterLog'
        """
        WebDriverWait(self.driver, timeout).until(
            lambda d: _has_accessibility_id(d, "워터로그")
            or _has_accessibility_id(d, "WaterLog"),
            message="가입 후 로그인 홈(워터로그) 또는 메인(WaterLog)이 나타나지 않음",
        )

    def sign_up_with_email(self, email: str, password: str):
        """로그인 홈 → 회원가입 → 가입 완료."""
        self.login.wait_for_login_home()
        self.login.open_email_sign_up()
        self.wait_for_sign_up_form()
        self.enter_email(email)
        self.enter_password(password)
        self.enter_confirm_password(password)
        self.accept_terms()
        self.tap_sign_up_submit()
        self.wait_until_signed_up()
