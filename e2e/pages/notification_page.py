from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time


# 이모지 유무와 무관하게 page_source / UiAutomator 매칭용
GOAL_NOTI_TITLE = "오늘 물섭취 목표 달성 💧"
GOAL_NOTI_TITLE_PREFIX = "오늘 물섭취 목표 달성"
GOAL_NOTI_MESSAGE = "하루 목표 8잔을 모두 마셨어요!"
WELCOME_MESSAGE = "WaterLog와 함께 건강한 수분습관을 시작해보세요!"
WELCOME_TITLE_PREFIX = "환영합니다"


class NotificationPage:
    """notification_screen.dart — 앱 내 알림 목록."""

    def __init__(self, driver, timeout: int = 25):
        self.driver = driver
        self.wait = WebDriverWait(driver, timeout)

    def _by_desc(self, desc: str):
        return (AppiumBy.ACCESSIBILITY_ID, desc)

    def wait_until_loaded(self):
        """
        알림 화면 진입 확인.
        메인 AppBar IconButton tooltip도 '알림'이라 ACCESSIBILITY_ID만으로는 부족하다.
        메인 물 UI가 사라진 뒤 AppBar 제목 '알림'이 보일 때까지 기다린다.
        """
        self.wait.until(
            lambda d: "물 한 잔 마셨나요?" not in d.page_source,
            message="알림 화면으로 이동하지 못함 (메인 물 UI가 그대로임)",
        )
        self.wait.until(
            EC.presence_of_element_located(self._by_desc("알림"))
        )

    def go_back(self):
        try:
            self.driver.find_element(
                AppiumBy.ACCESSIBILITY_ID, "Back"
            ).click()
            return
        except Exception:
            pass
        try:
            self.driver.find_element(
                AppiumBy.ACCESSIBILITY_ID, "뒤로가기"
            ).click()
            return
        except Exception:
            pass
        self.driver.back()

    def _source_has_goal(self) -> bool:
        source = self.driver.page_source
        return (
            GOAL_NOTI_TITLE_PREFIX in source
            or GOAL_NOTI_TITLE in source
            or GOAL_NOTI_MESSAGE in source
        )

    def count_goal_achieved(self) -> int:
        """제목 prefix 출현 횟수 (이모지 인코딩 차이 대비)."""
        source = self.driver.page_source
        return source.count(GOAL_NOTI_TITLE_PREFIX)

    def wait_for_goal_achieved(self, timeout: float = 25):
        """스트림 반영 지연을 고려해 목표 달성 알림이 보일 때까지 대기."""
        WebDriverWait(self.driver, timeout).until(
            lambda d: self._source_has_goal(),
            message=(
                f"목표 달성 알림이 없음 "
                f"(기대: '{GOAL_NOTI_TITLE_PREFIX}' / '{GOAL_NOTI_MESSAGE}')"
            ),
        )

    def assert_goal_achieved_present(self):
        self.wait_for_goal_achieved()
        source = self.driver.page_source
        assert GOAL_NOTI_TITLE_PREFIX in source or GOAL_NOTI_TITLE in source
        assert GOAL_NOTI_MESSAGE in source

    def assert_welcome_present(self, timeout: float = 20):
        WebDriverWait(self.driver, timeout).until(
            lambda d: WELCOME_MESSAGE in d.page_source
            or WELCOME_TITLE_PREFIX in d.page_source,
            message="환영(welcome) 알림이 목록에 없음",
        )
        source = self.driver.page_source
        assert WELCOME_MESSAGE in source or WELCOME_TITLE_PREFIX in source

    def wait_for_title(self, title: str, timeout: float = 20):
        WebDriverWait(self.driver, timeout).until(
            lambda d: title in d.page_source,
            message=f"알림 제목 '{title}' 이 목록에 없음",
        )

    def _click_center(self, element, y_offset: int = 0):
        """Flutter Text click 이 InkWell 로 안 전달될 때 좌표 탭."""
        rect = element.rect
        x = int(rect["x"] + rect["width"] / 2)
        y = int(rect["y"] + rect["height"] / 2 + y_offset)
        try:
            self.driver.execute_script(
                "mobile: clickGesture", {"x": x, "y": y}
            )
        except Exception:
            element.click()

    def tap_notification_by_title(self, title: str):
        """
        제목으로 알림 카드 탭 (읽음 처리).
        Semantics(onTap) / 좌표 탭을 함께 시도한다.
        """
        self.wait_for_title(title)

        el = None
        try:
            el = self.wait.until(
                EC.presence_of_element_located(self._by_desc(title))
            )
        except Exception:
            el = self.driver.find_element(
                AppiumBy.ANDROID_UIAUTOMATOR,
                f'new UiSelector().descriptionContains("{title}")',
            )

        # 1) 일반 click (Semantics onTap 이 있으면 여기서 처리됨)
        el.click()
        time.sleep(0.8)

        # 2) 카드 중앙 좌표 탭 (제목 아래 본문 쪽)
        self._click_center(el, y_offset=40)
        time.sleep(0.8)

        # 3) 메시지 텍스트가 있으면 그것도 탭
        try:
            msg = self.driver.find_element(
                AppiumBy.ACCESSIBILITY_ID, "읽음 처리 테스트용"
            )
            msg.click()
            self._click_center(msg, y_offset=0)
            time.sleep(0.5)
        except Exception:
            pass

    def tap_first_notification_card(self):
        """
        목록 첫 알림 카드 탭 (읽음 처리).
        title/message Text 또는 Card 영역을 탭한다.
        """
        for desc in (
            "E2E 미읽음 알림",
            GOAL_NOTI_TITLE_PREFIX,
            GOAL_NOTI_TITLE,
            WELCOME_TITLE_PREFIX,
            WELCOME_MESSAGE,
        ):
            try:
                if desc in self.driver.page_source:
                    self.tap_notification_by_title(desc)
                    return
            except Exception:
                continue

        raise AssertionError("탭할 알림 항목을 찾지 못함")
