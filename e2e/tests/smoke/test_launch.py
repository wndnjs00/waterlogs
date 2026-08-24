def test_app_launch(driver):
    """앱이 설치·실행되고 패키지가 WaterLog인지 확인한다."""
    assert driver.current_package == "com.juwon.waterlog"
