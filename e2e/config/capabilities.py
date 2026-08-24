from pathlib import Path

# e2e/config/capabilities.py → parents[2] == waterLogs 프로젝트 루트
PROJECT_ROOT = Path(__file__).resolve().parents[2]

APK_PATH = (
    PROJECT_ROOT
    / "build"
    / "app"
    / "outputs"
    / "flutter-apk"
    / "app-debug.apk"
)

ANDROID_CAPS = {
    "platformName": "Android",
    "appium:automationName": "UiAutomator2",
    "appium:deviceName": "Android Emulator",
    # flutter build apk --debug 결과물
    "appium:app": str(APK_PATH),
    # android/app/build.gradle.kts applicationId
    "appium:appPackage": "com.juwon.waterlog",
    # android/.../MainActivity.kt (package com.juwon.waterlog)
    "appium:appActivity": ".MainActivity",
    "appium:noReset": False,
    "appium:newCommandTimeout": 120,
    "appium:autoGrantPermissions": True,
}
