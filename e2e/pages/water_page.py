import re
import time

from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class WaterPage:
    """메인 화면 물 섭취 +/- (water_control_section / circular_water_progress)."""

    def __init__(self, driver, timeout: int = 25):
        self.driver = driver
        self.wait = WebDriverWait(driver, timeout)

    def _by_desc(self, desc: str):
        return (AppiumBy.ACCESSIBILITY_ID, desc)

    def wait_until_ready(self):
        """오늘 기록 UI가 뜬 뒤 +/- 조작 가능 상태."""
        self.wait.until(
            EC.presence_of_element_located(self._by_desc("WaterLog"))
        )
        # water_control_section.dart: '물 한 잔 마셨나요?'
        self.wait.until(
            EC.presence_of_element_located(self._by_desc("물 한 잔 마셨나요?"))
        )
        WebDriverWait(self.driver, self.wait._timeout).until(
            lambda d: self._status() is not None,
            message="물 섭취 상태 문구(N잔 더 마셔요! / 목표 달성)가 나타나지 않음",
        )

    def _status(self):
        """
        Returns:
          ("remaining", n)  — n잔 더 마셔요!
          ("goal", None)    — 🎉목표 달성!
          None              — 아직 없음
        """
        source = self.driver.page_source
        if "🎉목표 달성!" in source or "목표 달성!" in source:
            return ("goal", None)
        match = re.search(r"(\d+)잔 더 마셔요!", source)
        if match:
            return ("remaining", int(match.group(1)))
        return None

    def read_status(self):
        status = self._status()
        if status is None:
            raise AssertionError("물 섭취 상태 문구를 읽을 수 없음")
        return status

    def read_target_cups(self) -> int:
        # circular_water_progress: '/ $target 잔'
        match = re.search(r"/ (\d+) 잔", self.driver.page_source)
        if not match:
            raise AssertionError("목표 잔 수('/ N 잔')를 찾을 수 없음")
        return int(match.group(1))

    def estimate_cups(self) -> int:
        """
        상태 문구로 현재 잔 수 추정.
        - remaining: cups = target - remaining
        - goal: target 이상으로 간주 (정확한 초과분은 문구만으로는 모름)
        """
        target = self.read_target_cups()
        kind, remaining = self.read_status()
        if kind == "goal":
            return target
        return target - remaining

    def tap_plus(self):
        element = self.wait.until(
            EC.element_to_be_clickable(self._by_desc("+"))
        )
        element.click()

    def tap_minus(self):
        element = self.wait.until(
            EC.element_to_be_clickable(self._by_desc("-"))
        )
        element.click()

    def wait_status_changed(self, before, timeout: float = 10):
        end = time.time() + timeout
        while time.time() < end:
            current = self._status()
            if current is not None and current != before:
                return current
            time.sleep(0.25)
        raise AssertionError(
            f"물 섭취 상태가 변하지 않음 (이전={before}, 현재={self._status()})"
        )

    def tap_plus_times(self, times: int):
        for _ in range(times):
            before = self.read_status()
            self.tap_plus()
            # 목표 달성 후에도 + 하면 cups는 늘지만 문구는 goal 유지 → 변화 없을 수 있음
            try:
                self.wait_status_changed(before, timeout=4)
            except AssertionError:
                if self.read_status()[0] != "goal":
                    raise
                time.sleep(0.4)

    def tap_minus_times(self, times: int):
        for _ in range(times):
            before = self.read_status()
            self.tap_minus()
            self.wait_status_changed(before, timeout=4)

    def ensure_not_at_goal(self):
        kind, _ = self.read_status()
        if kind == "goal":
            before = self.read_status()
            self.tap_minus()
            self.wait_status_changed(before)

    def ensure_at_least_one_cup(self):
        if self.estimate_cups() < 1:
            before = self.read_status()
            self.tap_plus()
            self.wait_status_changed(before)

    def ensure_remaining(self, desired: int):
        """
        'desired잔 더 마셔요!' 상태가 될 때까지 +/-.
        desired == target 이면 0잔, desired == 1 이면 목표 직전.
        """
        target = self.read_target_cups()
        if desired < 1 or desired > target:
            raise ValueError(f"desired는 1..{target} 범위여야 함: {desired}")

        for _ in range(60):
            kind, rem = self.read_status()
            if kind == "remaining" and rem == desired:
                return
            before = self.read_status()
            if kind == "goal":
                self.tap_minus()
            elif rem > desired:
                # 잔이 부족 → +
                self.tap_plus()
            else:
                # rem < desired → 잔이 많음 → −
                self.tap_minus()
            self.wait_status_changed(before, timeout=5)

        raise AssertionError(f"remaining={desired} 상태로 맞추지 못함: {self.read_status()}")

    def ensure_zero_cups(self):
        """오늘 0잔 (= remaining == target)."""
        target = self.read_target_cups()
        for _ in range(60):
            kind, rem = self.read_status()
            if kind == "remaining" and rem == target:
                return
            before = self.read_status()
            self.tap_minus()
            try:
                self.wait_status_changed(before, timeout=4)
            except AssertionError:
                # 이미 0잔이면 − 해도 안 바뀜
                kind2, rem2 = self.read_status()
                if kind2 == "remaining" and rem2 == target:
                    return
                raise
        raise AssertionError(f"0잔으로 맞추지 못함: {self.read_status()}")

    def ensure_at_least_cups(self, n: int):
        """최소 n잔 확보 (목표 미달 문구가 보이는 범위에서)."""
        target = self.read_target_cups()
        if n > target:
            raise ValueError("목표를 넘는 잔 수는 remaining 문구만으로 맞추기 어려움")
        desired_remaining = target - n
        if desired_remaining == 0:
            self.ensure_remaining(1)
            before = self.read_status()
            self.tap_plus()
            self.wait_status_changed(before)
            return
        self.ensure_remaining(desired_remaining)

    def tap_save(self):
        """저장 버튼 — hasUnsavedChanges일 때만 활성."""
        element = self.wait.until(
            EC.element_to_be_clickable(self._by_desc("저장"))
        )
        element.click()

    def wait_save_finished(self, timeout: float = 45):
        """
        저장 완료 대기.

        저장 중에는 버튼 라벨 '저장'이 ProgressIndicator로 바뀌고(ACCESSIBILITY_ID 사라짐),
        끝나면 '저장'이 다시 보이며 enabled=false 가 된다.

        예전 구현은 탭 직후 enabled=false(isUpdating)만 보고 즉시 return 해서
        Firestore 알림/뱃지 생성 전에 다음 스텝으로 넘어가는 레이스가 있었다.
        """
        end = time.time() + timeout
        saw_spinner = False  # '저장' 라벨이 사라진 적 있음
        stable_done = 0

        while time.time() < end:
            try:
                el = self.driver.find_element(*self._by_desc("저장"))
                enabled = el.get_attribute("enabled") == "true"
                if enabled:
                    stable_done = 0
                else:
                    # 라벨이 다시 보이는 + 비활성 = 저장 완료(또는 미시작)
                    if saw_spinner:
                        stable_done += 1
                        if stable_done >= 2:
                            # Firestore 스냅샷 → 알림 목록 반영 여유
                            time.sleep(1.2)
                            return
                    else:
                        # 스피너를 못 본 경우(매우 빠른 저장) — 짧게 더 기다림
                        stable_done += 1
                        if stable_done >= 10:  # ~2.5s
                            time.sleep(1.2)
                            return
            except Exception:
                # '저장' 없음 → 스피너 표시 중
                saw_spinner = True
                stable_done = 0
            time.sleep(0.25)

        raise AssertionError(
            f"저장 완료를 확인하지 못함 (spinner_seen={saw_spinner})"
        )

    def reach_goal_and_save(self):
        """목표 직전 → + → 목표 문구 → 저장."""
        self.ensure_remaining(1)
        before = self.read_status()
        self.tap_plus()
        after = self.wait_status_changed(before)
        if after[0] != "goal":
            raise AssertionError(f"목표 달성 문구가 아님: {after}")
        self.tap_save()
        self.wait_save_finished()
