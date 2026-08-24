"""
에뮬레이터/기기 네트워크 차단 (TC-ERR-01).

adb 로 Wi‑Fi·모바일 데이터를 끄고, 테스트 종료 시 반드시 복구한다.
Appium 세션(USB/emulator adb)은 보통 유지된다.
"""

from __future__ import annotations

import subprocess
import time
from typing import Optional


def device_serial(driver) -> Optional[str]:
    caps = driver.capabilities or {}
    return caps.get("deviceUDID") or caps.get("udid") or caps.get("deviceName")


def _adb(serial: Optional[str], *args: str, timeout: float = 30) -> subprocess.CompletedProcess:
    cmd = ["adb"]
    if serial and serial not in ("Android Emulator", "emulator"):
        # deviceName 이 논리명일 수 있음 → -s 는 udid 일 때만
        if serial.startswith("emulator-") or ":" in serial or len(serial) >= 8:
            cmd.extend(["-s", serial])
    cmd.extend(args)
    return subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        timeout=timeout,
        check=False,
    )


def _resolve_serial(driver) -> Optional[str]:
    serial = device_serial(driver)
    if serial and (serial.startswith("emulator-") or ":" in serial):
        return serial
    # fallback: adb devices 첫 번째 device
    result = _adb(None, "devices")
    for line in (result.stdout or "").splitlines():
        if "\tdevice" in line:
            return line.split("\t")[0].strip()
    return serial


class NetworkControl:
    """테스트용 네트워크 on/off."""

    def __init__(self, driver):
        self.driver = driver
        self.serial = _resolve_serial(driver)

    def go_offline(self):
        """Wi‑Fi + 데이터 차단 (비행기 모드는 에뮬 adb 이슈가 있어 기본 미사용)."""
        _adb(self.serial, "shell", "svc", "wifi", "disable")
        _adb(self.serial, "shell", "svc", "data", "disable")
        time.sleep(2.0)

    def go_online(self):
        _adb(self.serial, "shell", "svc", "wifi", "enable")
        _adb(self.serial, "shell", "svc", "data", "enable")
        # 연결 복구 여유
        time.sleep(3.0)
