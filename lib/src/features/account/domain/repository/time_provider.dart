abstract class TimeProvider {
  String nowDateTimeString();
  String nowDateString();
  String yesterdayString();
  String weekStart();
  String monthStart();
  String waterLogDateString();
  // 알림 목록 표시용 시간 (HH:mm)
  String formatNotificationTime(String dateTime);
}