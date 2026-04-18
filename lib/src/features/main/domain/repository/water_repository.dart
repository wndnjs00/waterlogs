import '../model/water_log.dart';

abstract class WaterRepository {
  Future<WaterLog?> getTodayLog(String uid, String date);

  /// 물 기록 저장 + 뱃지/알림 처리 후, "이번 저장으로 새로 획득된 뱃지 수"를 반환
  Future<int> saveWithAchievement(String uid, WaterLog waterLog);

  Future<List<WaterLog>> getWeeklyLogs(String uid, String start, String end);

  Future<List<WaterLog>> getMonthlyLogs(String uid, String start, String end);
}
