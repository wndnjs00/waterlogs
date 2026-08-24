"""물 섭취 E2E: TC-WATER-02 ~ TC-WATER-09."""

import time

from pages.login_page import LoginPage
from pages.main_page import MainPage
from pages.water_page import WaterPage


def _login_to_water(driver, e2e_credentials) -> WaterPage:
    email, password = e2e_credentials
    LoginPage(driver).login_with_email(email, password)
    MainPage(driver).wait_until_loaded()
    water = WaterPage(driver)
    water.wait_until_ready()
    return water


# ----- TC-WATER-02 / 03 -----


def test_water_plus_increases_cup(driver, e2e_credentials):
    """TC-WATER-02: + 1회 → 잔 수 +1, 남은 잔 문구 갱신."""
    water = _login_to_water(driver, e2e_credentials)
    water.ensure_not_at_goal()

    target = water.read_target_cups()
    before_cups = water.estimate_cups()
    before_status = water.read_status()

    water.tap_plus()
    after_status = water.wait_status_changed(before_status)
    after_cups = water.estimate_cups()

    assert after_cups == before_cups + 1

    kind, remaining = after_status
    if after_cups >= target:
        assert kind == "goal"
    else:
        assert kind == "remaining"
        assert remaining == target - after_cups
        assert remaining == before_status[1] - 1


def test_water_minus_decreases_cup(driver, e2e_credentials):
    """TC-WATER-03: 1잔 이상에서 − 1회 → 잔 수 −1."""
    water = _login_to_water(driver, e2e_credentials)
    water.ensure_at_least_one_cup()

    target = water.read_target_cups()
    before_cups = water.estimate_cups()
    before_status = water.read_status()
    assert before_cups >= 1

    water.tap_minus()
    after_status = water.wait_status_changed(before_status)
    after_cups = water.estimate_cups()

    assert after_cups == before_cups - 1

    kind, remaining = after_status
    if after_cups >= target:
        assert kind == "goal"
    else:
        assert kind == "remaining"
        assert remaining == target - after_cups


# ----- TC-WATER-04 -----


def test_water_reaches_goal_message(driver, e2e_credentials):
    """
    TC-WATER-04: 목표 직전(remaining=1)에서 + → '🎉목표 달성!'
    (문서의 7잔 시드 대신 UI로 목표-1잔까지 맞춤)
    """
    water = _login_to_water(driver, e2e_credentials)
    water.ensure_remaining(1)

    before = water.read_status()
    assert before == ("remaining", 1)

    water.tap_plus()
    after = water.wait_status_changed(before)

    assert after[0] == "goal"
    assert "목표 달성!" in driver.page_source


# ----- TC-WATER-05 -----


def test_water_plus_three_times(driver, e2e_credentials):
    """
    TC-WATER-05: + 3회 연속 → 잔 수 N+3, 남은 잔 문구 동기화.
    목표를 넘기지 않도록 remaining ≥ 4 인 상태에서 시작.
    """
    water = _login_to_water(driver, e2e_credentials)
    water.ensure_remaining(4)

    target = water.read_target_cups()
    before_cups = water.estimate_cups()
    before_status = water.read_status()
    assert before_status == ("remaining", 4)

    water.tap_plus_times(3)

    after_status = water.read_status()
    after_cups = water.estimate_cups()

    assert after_cups == before_cups + 3
    assert after_status == ("remaining", 1)
    assert after_status[1] == before_status[1] - 3
    assert after_cups == target - 1


# ----- TC-WATER-06 -----


def test_water_minus_three_times(driver, e2e_credentials):
    """
    TC-WATER-06: 잔 ≥ 3에서 − 3회 → 정확히 3 감소.
    """
    water = _login_to_water(driver, e2e_credentials)
    water.ensure_at_least_cups(3)

    before_cups = water.estimate_cups()
    before_status = water.read_status()
    assert before_cups >= 3
    assert before_status[0] == "remaining"

    water.tap_minus_times(3)

    after_status = water.read_status()
    after_cups = water.estimate_cups()

    assert after_cups == before_cups - 3
    assert after_status[0] == "remaining"
    assert after_status[1] == before_status[1] + 3


# ----- TC-WATER-07 -----


def test_water_minus_at_zero_stays_zero(driver, e2e_credentials):
    """
    TC-WATER-07: 0잔에서 − → 0 미만으로 내려가지 않음.
    """
    water = _login_to_water(driver, e2e_credentials)
    water.ensure_zero_cups()

    target = water.read_target_cups()
    before = water.read_status()
    assert before == ("remaining", target)
    assert water.estimate_cups() == 0

    water.tap_minus()
    time.sleep(1.5)

    after = water.read_status()
    assert after == before
    assert water.estimate_cups() == 0


# ----- TC-WATER-08 -----


def test_water_plus_minus_round_trip(driver, e2e_credentials):
    """
    TC-WATER-08: +2 → −1 → +1 후 최종 잔 = N+2.
    목표를 넘기지 않도록 remaining=4에서 시작 (N = target-4).
    """
    water = _login_to_water(driver, e2e_credentials)
    water.ensure_remaining(4)

    before_cups = water.estimate_cups()
    before_status = water.read_status()
    assert before_status == ("remaining", 4)

    # + + − +
    water.tap_plus_times(2)
    water.tap_minus_times(1)
    water.tap_plus_times(1)

    after_cups = water.estimate_cups()
    after_status = water.read_status()

    assert after_cups == before_cups + 2
    assert after_status == ("remaining", 2)
    assert after_status[1] == before_status[1] - 2


# ----- TC-WATER-09 -----


def test_water_goal_message_toggles_with_plus_minus(driver, e2e_credentials):
    """
    TC-WATER-09: 1잔 더 → + → 목표 달성 → − → 다시 1잔 더.
    """
    water = _login_to_water(driver, e2e_credentials)
    water.ensure_remaining(1)

    assert water.read_status() == ("remaining", 1)

    before = water.read_status()
    water.tap_plus()
    at_goal = water.wait_status_changed(before)
    assert at_goal[0] == "goal"
    assert "목표 달성!" in driver.page_source

    before_goal = water.read_status()
    water.tap_minus()
    after = water.wait_status_changed(before_goal)
    assert after == ("remaining", 1)
