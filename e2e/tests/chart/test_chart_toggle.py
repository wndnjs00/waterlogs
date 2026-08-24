"""TC-CHART-01: 주간 ↔ 월간 차트 토글 (기존 E2E 계정)."""

from pages.chart_page import ChartPage
from pages.water_helpers import login_to_water


def test_weekly_monthly_chart_toggle(driver, e2e_credentials):
    """
    TC-CHART-01:
      주간 수분 섭취량 기본 → 월간 평균 섭취량 → 다시 주간.
      차트 픽셀이 아니라 세그먼트/전용 텍스트만 검증.
    """
    login_to_water(driver, e2e_credentials)
    chart = ChartPage(driver)

    chart.scroll_chart_into_view()
    chart.assert_weekly_visible()

    chart.tap_monthly()
    chart.assert_monthly_visible()

    chart.tap_weekly()
    chart.assert_weekly_visible()
