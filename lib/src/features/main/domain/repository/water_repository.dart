import '../model/water_log.dart';

abstract class WaterRepository {
  Future<WaterLog?> getTodayLog(String uid, String date);

  Future<void> saveWithAchievement(String uid, WaterLog waterLog);

  Future<List<WaterLog>> getWeeklyLogs(String uid, String start, String end);

  Future<List<WaterLog>> getMonthlyLogs(String uid, String start, String end);
}
