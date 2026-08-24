from appium.webdriver.common.appiumby import AppiumBy
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
import time
import re


WEEKLY_TAB = "주간 수분 섭취량"
MONTHLY_TAB = "월간 평균 섭취량"
MONTHLY_AVG_PREFIX = "이번 달 평균"
WEEKLY_HINT = "1잔 = 250ml"
MONTHLY_PERIOD = "기간"


class ChartPage:
    """메인 하단 주간/월간 차트 세그먼트 (chart_segment_control)."""

    def __init__(self, driver, timeout: int = 25):
        self.driver = driver
        self.wait = WebDriverWait(driver, timeout)

    def _by_desc(self, desc: str):
        return (AppiumBy.ACCESSIBILITY_ID, desc)

    def _swipe_up(self):
        size = self.driver.get_window_size()
        self.driver.swipe(
            size["width"] // 2,
            int(size["height"] * 0.75),
            size["width"] // 2,
            int(size["height"] * 0.3),
            600,
        )
        time.sleep(0.4)

    def scroll_chart_into_view(self):
        """차트 세그먼트가 보이도록 스크롤."""
        try:
            self.driver.find_element(
                AppiumBy.ANDROID_UIAUTOMATOR,
                'new UiScrollable(new UiSelector().scrollable(true)).'
                f'scrollIntoView(new UiSelector().description("{WEEKLY_TAB}"))',
            )
            return
        except Exception:
            pass

        for _ in range(5):
            if WEEKLY_TAB in self.driver.page_source:
                return
            self._swipe_up()

        self.wait.until(
            lambda d: WEEKLY_TAB in d.page_source,
            message="주간/월간 차트 세그먼트를 찾지 못함",
        )

    def _tap_segment(self, label: str):
        self.scroll_chart_into_view()
        # description 또는 text 로 탭 (Flutter InkWell)
        try:
            self.driver.find_element(*self._by_desc(label)).click()
            return
        except Exception:
            pass
        try:
            self.driver.find_element(
                AppiumBy.ANDROID_UIAUTOMATOR,
                f'new UiSelector().description("{label}")',
            ).click()
            return
        except Exception:
            pass
        self.driver.find_element(
            AppiumBy.ANDROID_UIAUTOMATOR,
            f'new UiSelector().text("{label}")',
        ).click()

    def tap_weekly(self):
        self._tap_segment(WEEKLY_TAB)
        self.wait.until(
            lambda d: WEEKLY_HINT in d.page_source
            or "※ 1잔" in d.page_source,
            message="주간 차트로 전환되지 않음",
        )

    def tap_monthly(self):
        """월간 탭 후 월간 전용 UI(기간 / 주차 / 평균)가 보일 때까지 대기·스크롤."""
        self._tap_segment(MONTHLY_TAB)

        end = time.time() + 15
        while time.time() < end:
            source = self.driver.page_source
            if (
                MONTHLY_PERIOD in source
                or "1주차" in source
                or MONTHLY_AVG_PREFIX in source
            ):
                # 평균 문구는 차트 아래라 한 번 더 스크롤
                if MONTHLY_AVG_PREFIX not in source:
                    self._swipe_up()
                    time.sleep(0.5)
                return
            # 탭이 안 먹었을 수 있음 → 재시도
            try:
                self._tap_segment(MONTHLY_TAB)
            except Exception:
                pass
            self._swipe_up()
            time.sleep(0.5)

        raise TimeoutException(
            "월간 차트로 전환되지 않음 "
            f"(기대: '{MONTHLY_PERIOD}' / '1주차' / '{MONTHLY_AVG_PREFIX}')",
            None,
            None,
        )

    def assert_weekly_visible(self):
        self.scroll_chart_into_view()
        source = self.driver.page_source
        assert WEEKLY_TAB in source
        assert WEEKLY_HINT in source or "※ 1잔" in source
        # 월간 전용 마커가 없어야 함
        assert MONTHLY_AVG_PREFIX not in source
        assert "1주차" not in source

    def assert_monthly_visible(self):
        # 이미 tap_monthly 에서 전환 확인. 평균 문구까지 스크롤
        end = time.time() + 12
        while time.time() < end:
            source = self.driver.page_source
            if MONTHLY_AVG_PREFIX in source and "잔/일" in source:
                assert MONTHLY_TAB in source
                assert (
                    re.search(r"이번 달 평균[:\s]*[\d.]+잔/일", source)
                    or MONTHLY_AVG_PREFIX in source
                )
                return
            # 월간 UI는 있는데 평균이 화면 밖
            if MONTHLY_PERIOD in source or "1주차" in source:
                self._swipe_up()
                time.sleep(0.4)
                continue
            time.sleep(0.4)

        raise AssertionError(
            f"월간 평균 문구('{MONTHLY_AVG_PREFIX}')를 찾지 못함. "
            "월간 탭 전환 또는 스크롤 실패 가능"
        )
