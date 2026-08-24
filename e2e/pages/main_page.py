from appium.webdriver.common.appiumby import AppiumBy
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class MainPage:
    """로그인 성공 후 메인 셸(main_shell_page.dart)."""

    def __init__(self, driver, timeout: int = 25):
        self.driver = driver
        self.wait = WebDriverWait(driver, timeout)

    def _by_desc(self, desc: str):
        return (AppiumBy.ACCESSIBILITY_ID, desc)

    def _edit_text(self, index: int = 0):
        return (
            AppiumBy.ANDROID_UIAUTOMATOR,
            f'new UiSelector().className("android.widget.EditText").instance({index})',
        )

    def _app_bar_image_views(self):
        """
        AppBar 상단의 clickable ImageView를 x좌표(왼쪽→오른쪽)로 정렬해 반환.

        actions 순서(왼쪽→오른쪽):
          뱃지 → (알림 버튼) → 로그아웃 → 회원탈퇴(가장 오른쪽)
        """
        images = self.driver.find_elements(
            AppiumBy.CLASS_NAME, "android.widget.ImageView"
        )
        top = []
        for img in images:
            try:
                rect = img.rect
                if (
                    rect.get("y", 9999) < 300
                    and rect.get("height", 0) >= 16
                    and img.get_attribute("clickable") == "true"
                ):
                    top.append(img)
            except Exception:
                continue
        top.sort(key=lambda e: e.rect.get("x", 0))
        return top

    def _tap_app_bar_image_from_right(self, index_from_right: int):
        def _find(driver):
            # driver unused; use self for fresh query each poll
            images = []
            for img in driver.find_elements(
                AppiumBy.CLASS_NAME, "android.widget.ImageView"
            ):
                try:
                    rect = img.rect
                    if (
                        rect.get("y", 9999) < 300
                        and rect.get("height", 0) >= 16
                        and img.get_attribute("clickable") == "true"
                    ):
                        images.append(img)
                except Exception:
                    continue
            images.sort(key=lambda e: e.rect.get("x", 0))
            if len(images) <= index_from_right:
                return False
            return images[-(index_from_right + 1)]

        element = self.wait.until(_find)
        element.click()

    def _has_desc(self, desc: str) -> bool:
        try:
            self.driver.find_element(AppiumBy.ACCESSIBILITY_ID, desc)
            return True
        except Exception:
            return False

    def wait_until_loaded(self):
        self.wait.until(
            EC.presence_of_element_located(self._by_desc("WaterLog"))
        )

    def is_loaded(self) -> bool:
        return self._has_desc("WaterLog")

    def tap_logout(self):
        # 가장 오른쪽=회원탈퇴(0), 그 왼쪽=로그아웃(1)
        self._tap_app_bar_image_from_right(1)
        try:
            WebDriverWait(self.driver, 2).until(
                EC.presence_of_element_located(
                    self._by_desc("정말 탈퇴하시겠습니까?")
                )
            )
            raise AssertionError(
                "로그아웃을 눌렀는데 회원탈퇴 다이얼로그가 열림 "
                "(잘못된 AppBar 아이콘을 탭함)"
            )
        except TimeoutException:
            pass

    def tap_notifications(self):
        """AppBar 알림 아이콘 (tooltip: 알림) → 알림 화면."""
        try:
            element = self.wait.until(
                EC.element_to_be_clickable(self._by_desc("알림"))
            )
            element.click()
        except TimeoutException:
            # fallback: AppBar 영역 Button (IconButton)
            def _find(driver):
                for btn in driver.find_elements(
                    AppiumBy.CLASS_NAME, "android.widget.Button"
                ):
                    try:
                        if btn.rect.get("y", 9999) < 300:
                            return btn
                    except Exception:
                        continue
                return False

            self.wait.until(_find).click()

        # 메인에 남아 있으면(툴팁 '알림'만 클릭된 상태) 실패로 간주
        WebDriverWait(self.driver, 15).until(
            lambda d: "물 한 잔 마셨나요?" not in d.page_source,
            message="알림 아이콘 탭 후에도 메인 화면이 유지됨",
        )

    def tap_badge(self):
        """AppBar 뱃지 아이콘 (Semantics label: 뱃지)."""
        try:
            element = self.wait.until(
                EC.element_to_be_clickable(self._by_desc("뱃지"))
            )
            element.click()
            return
        except TimeoutException:
            pass

        # fallback: AppBar 상단 clickable ImageView 중 가장 왼쪽
        def _find(driver):
            images = []
            for img in driver.find_elements(
                AppiumBy.CLASS_NAME, "android.widget.ImageView"
            ):
                try:
                    rect = img.rect
                    if (
                        rect.get("y", 9999) < 300
                        and rect.get("height", 0) >= 16
                        and img.get_attribute("clickable") == "true"
                    ):
                        images.append(img)
                except Exception:
                    continue
            images.sort(key=lambda e: e.rect.get("x", 0))
            return images[0] if images else False

        self.wait.until(_find).click()

    def tap_withdraw(self):
        # AppBar에서 가장 오른쪽 ImageView = 회원탈퇴
        self._tap_app_bar_image_from_right(0)

    def wait_for_withdraw_dialog(self):
        self.wait.until(
            EC.presence_of_element_located(
                self._by_desc("정말 탈퇴하시겠습니까?")
            )
        )

    def confirm_withdraw_first_step(self):
        element = self.wait.until(
            EC.element_to_be_clickable(self._by_desc("탈퇴하기"))
        )
        element.click()

    def enter_withdraw_password(self, password: str):
        self.wait.until(
            EC.presence_of_element_located(
                self._by_desc("본인 확인을 위해 비밀번호를 입력해주세요.")
            )
        )
        field = self.wait.until(
            EC.presence_of_element_located(self._edit_text(0))
        )
        field.click()
        field.clear()
        field.send_keys(password)

    def confirm_withdraw_final(self):
        element = self.wait.until(
            EC.element_to_be_clickable(self._by_desc("탈퇴하기"))
        )
        element.click()

    def logout(self):
        """로그아웃 → 로그인 홈 복귀."""
        self.tap_logout()

    def withdraw_with_email_password(self, password: str):
        """회원탈퇴(이메일 재인증 포함) → 로그인 홈 복귀."""
        self.tap_withdraw()
        self.wait_for_withdraw_dialog()
        self.confirm_withdraw_first_step()
        self.enter_withdraw_password(password)
        self.confirm_withdraw_final()
