from appium.webdriver.common.appiumby import AppiumBy
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time


DAY_2L_NAME = "하루 2L 달성"
WEEK_7_NAME = "7일 연속 달성"
MONTH_30_NAME = "30일 연속 달성"
KING_6M_NAME = "6개월 꾸준함의 왕"


class BadgePage:
    """badge_screen.dart — 물뱃지 목록 / 획득 다이얼로그."""

    def __init__(self, driver, timeout: int = 25):
        self.driver = driver
        self.wait = WebDriverWait(driver, timeout)

    def _by_desc(self, desc: str):
        return (AppiumBy.ACCESSIBILITY_ID, desc)

    def _on_badge_screen(self) -> bool:
        source = self.driver.page_source
        return (
            "물뱃지" in source
            or "새로운 뱃지 획득" in source
            or "뱃지를 획득해보세요" in source
            or "획득완료" in source
        )

    def wait_until_loaded(self):
        """AppBar '물뱃지' 또는 획득 다이얼로그/그리드가 보일 때까지."""
        self.wait.until(
            lambda d: self._on_badge_screen(),
            message="뱃지 화면으로 이동하지 못함",
        )

    def dismiss_earned_dialog_if_any(self):
        """획득 다이얼로그가 뜨면 뒤로가기로 닫기."""
        try:
            WebDriverWait(self.driver, 5).until(
                lambda d: "새로운 뱃지 획득" in d.page_source
            )
            self.driver.back()
            time.sleep(0.5)
        except TimeoutException:
            pass

    def dismiss_all_earned_dialogs(self, max_count: int = 5):
        """연속 획득 시 다이얼로그가 여러 장 뜰 수 있음."""
        for _ in range(max_count):
            if "새로운 뱃지 획득" not in self.driver.page_source:
                break
            self.driver.back()
            time.sleep(0.7)

    def assert_day_2l_acquired(self):
        self.assert_badge_name_visible(DAY_2L_NAME)

    def assert_badge_name_visible(self, name: str, timeout: float = 30):
        """
        획득 다이얼로그 또는 그리드에 뱃지 이름이 보일 때까지 대기.

        day_2L + streak 뱃지를 같이 받으면 다이얼로그가 순서대로 뜬다.
        이름 확인 전에 무조건 dismiss 하면 현재 다이얼로그에만 있는
        streak 이름을 놓칠 수 있어, 보이면 즉시 성공 / 아니면 다음 다이얼로그로.
        """
        end = time.time() + timeout
        while time.time() < end:
            source = self.driver.page_source
            if name in source:
                return
            if "새로운 뱃지 획득" in source:
                self.driver.back()
                time.sleep(0.8)
                continue
            time.sleep(0.4)

        raise TimeoutException(
            f"뱃지 '{name}' 가 화면에 없음",
            None,
            None,
        )

    def go_back(self):
        try:
            self.driver.find_element(
                AppiumBy.ACCESSIBILITY_ID, "Back"
            ).click()
            return
        except Exception:
            pass
        self.driver.back()
