import '../model/water_log.dart';
import '../repository/water_repository.dart';

class WaterUseCase {
  final WaterRepository _repository;

  WaterUseCase(this._repository);

  Future<WaterLog?> getToday(String uid, String date) =>
      _repository.getTodayLog(uid, date);

  Future<int> saveWithAchievement(String uid, WaterLog log) =>
      _repository.saveWithAchievement(uid, log);

  Future<List<WaterLog>> weekly(String uid, String start, String end) =>
      _repository.getWeeklyLogs(uid, start, end);

  Future<List<WaterLog>> monthly(String uid, String start, String end) =>
      _repository.getMonthlyLogs(uid, start, end);
}
