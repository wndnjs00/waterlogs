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

  /// 캘린더 월 이동용. [year]-[month]의 1일~말일(yyyy-MM-dd) 범위로 조회한다.
  Future<List<WaterLog>> logsInMonth(String uid, int year, int month) {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final start = '$y-$m-01';
    final lastDay = DateTime(year, month + 1, 0).day;
    final end = '$y-$m-${lastDay.toString().padLeft(2, '0')}';
    return _repository.getMonthlyLogs(uid, start, end);
  }
}
