from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class LoginPage:
    """LoginScreen → SignInScreen 이메일 로그인 플로우."""

    def __init__(self, driver, timeout: int = 20):
        self.driver = driver
        self.wait = WebDriverWait(driver, timeout)

    def _by_desc(self, desc: str):
        return (AppiumBy.ACCESSIBILITY_ID, desc)

    def _edit_text(self, index: int):
        return (
            AppiumBy.ANDROID_UIAUTOMATOR,
            f'new UiSelector().className("android.widget.EditText").instance({index})',
        )

    def _hide_keyboard(self):
        try:
            self.driver.hide_keyboard()
        except Exception:
            try:
                # KEYCODE_BACK — 키보드만 닫히는 경우가 많음
                self.driver.press_keycode(4)
            except Exception:
                pass

    def _fill_edit(self, index: int, text: str):
        """Flutter TextField에 안정적으로 입력 (onChanged 유도)."""
        element = self.wait.until(
            EC.presence_of_element_located(self._edit_text(index))
        )
        element.click()
        try:
            element.clear()
        except Exception:
            pass
        # 한 글자씩내면 Flutter onChanged가 더 잘 타는 경우가 있음
        element.send_keys(text)

    def wait_for_login_home(self):
        self.wait.until(EC.presence_of_element_located(self._by_desc("워터로그")))

    def open_email_sign_in(self):
        element = self.wait.until(
            EC.element_to_be_clickable(self._by_desc("기존 계정으로 로그인하기"))
        )
        element.click()

    def open_email_sign_up(self):
        element = self.wait.until(
            EC.element_to_be_clickable(self._by_desc("이메일로 회원가입"))
        )
        element.click()

    def wait_for_sign_in_form(self):
        self.wait.until(
            EC.presence_of_element_located(self._by_desc("이메일로 로그인"))
        )

    def enter_email(self, email: str):
        self._fill_edit(0, email)

    def enter_password(self, password: str):
        self._fill_edit(1, password)
        self._hide_keyboard()

    def tap_login_submit(self):
        """
        이메일·비밀번호가 유효해야 버튼이 활성화됨 (sign_in_screen.dart).
        키보드에 가리거나 disabled면 clickable 대기가 실패하므로
        키보드 닫기 + enabled 확인 후 탭.
        """
        self._hide_keyboard()
        # 포커스 해제 → Flutter setState/검증 반영
        try:
            self.driver.find_element(*self._by_desc("이메일로 로그인")).click()
        except Exception:
            pass

        def _enabled_submit(driver):
            try:
                el = driver.find_element(*self._by_desc("로그인 하기"))
                if el.get_attribute("enabled") == "true":
                    return el
            except Exception:
                pass
            return False

        element = WebDriverWait(self.driver, self.wait._timeout).until(
            _enabled_submit,
            message=(
                "'로그인 하기' 버튼이 활성화되지 않음. "
                "이메일/비밀번호 형식이 유효한지, 입력이 Flutter에 반영됐는지 확인"
            ),
        )
        element.click()

    def open_sign_in_form(self):
        self.wait_for_login_home()
        self.open_email_sign_in()
        self.wait_for_sign_in_form()

    def wait_for_auth_error(self, *messages: str, timeout: int = 20):
        def _found(driver):
            for msg in messages:
                try:
                    driver.find_element(AppiumBy.ACCESSIBILITY_ID, msg)
                    return True
                except Exception:
                    if msg in driver.page_source:
                        return True
            return False

        WebDriverWait(self.driver, timeout).until(
            _found,
            message=f"인증 오류 메시지가 나타나지 않음: {messages}",
        )

    def login_with_email(self, email: str, password: str):
        self.wait_for_login_home()
        self.open_email_sign_in()
        self.wait_for_sign_in_form()
        self.enter_email(email)
        self.enter_password(password)
        self.tap_login_submit()
