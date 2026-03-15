import 'package:waterlogs/src/features/account/domain/repository/time_provider.dart';
import 'package:waterlogs/src/features/main/domain/constants/badge_type.dart';
import 'package:waterlogs/src/features/main/domain/model/water_log.dart';
import 'package:waterlogs/src/features/main/domain/repository/water_repository.dart';
import 'package:waterlogs/src/features/main/data/datasource/water_remote_datasource.dart';
import 'package:waterlogs/src/features/main/data/mapper/water_log_mapper.dart';
import 'package:waterlogs/src/features/main/data/model/save_with_achievement_result.dart';
import 'package:waterlogs/src/features/main/data/model/water_log_dto.dart';
import 'package:waterlogs/src/features/main/domain/util/streak_calculator.dart';

class WaterRepositoryImpl implements WaterRepository {
  WaterRepositoryImpl(this._dataSource, this._timeProvider);

  final WaterRemoteDataSource _dataSource;
  final TimeProvider _timeProvider;

  @override
  Future<WaterLog?> getTodayLog(String uid, String date) async {
    final dto = await _dataSource.getTodayLog(uid, date);
    return dto != null ? WaterLogMapper.toDomain(dto) : null;
  }

  @override
  Future<void> saveWithAchievement(String uid, WaterLog waterLog) async {
    final dto = WaterLogMapper.toDto(waterLog);
    final yesterday = _timeProvider.yesterdayString();
    final now = _timeProvider.nowDateTimeString();

    await _dataSource.saveWithAchievement(
      uid: uid,
      dto: dto,
      yesterday: yesterday,
      nowDateTimeString: now,
      compute: (userData, logExists, yesterday) => _computeSaveResult(
        userData: userData,
        logExists: logExists,
        waterLog: waterLog,
        yesterday: yesterday,
      ),
    );
  }

  SaveWithAchievementResult _computeSaveResult({
    required Map<String, dynamic>? userData,
    required bool logExists,
    required WaterLog waterLog,
    required String yesterday,
  }) {
    final data = userData ?? {};
    final dailyGoal = (data['dailyGoal'] as num?)?.toInt() ?? 8;
    final currentStreak = (data['streakDays'] as num?)?.toInt() ?? 0;
    final lastGoalDate = data['lastGoalAchievedDate'] as String?;
    final totalDays = (data['totalDays'] as num?)?.toInt() ?? 0;
    final goalAchievedDate = data['goalAchievedDate'] as String?;

    final isFirstRecordToday = !logExists;
    final reachedGoalFirstTime = waterLog.cups >= dailyGoal && goalAchievedDate != waterLog.date;

    final newStreak = StreakCalculator.calculate(
      lastGoalDate: lastGoalDate,
      today: waterLog.date,
      yesterday: yesterday,
      currentStreak: currentStreak,
      reachedGoalFirstTime: reachedGoalFirstTime,
    );

    final updates = <String, dynamic>{
      'streakDays': newStreak,
      'lastDrinkDate': waterLog.date,
    };

    if (isFirstRecordToday) {
      updates['totalDays'] = totalDays + 1;
    }

    if (reachedGoalFirstTime) {
      updates['goalAchievedDate'] = waterLog.date;
      updates['lastGoalAchievedDate'] = waterLog.date;
    }

    String? streakBadgeDocId;

    switch (newStreak) {
      case 7:
        streakBadgeDocId = BadgeType.week7days;
        break;
      case 30:
        streakBadgeDocId = BadgeType.month30days;
        break;
      case 180:
        streakBadgeDocId = BadgeType.king6months;
        break;
    }

    return SaveWithAchievementResult(
      userUpdate: updates,
      createGoalNotification: reachedGoalFirstTime,
      createGoalBadge: reachedGoalFirstTime,
      streakBadgeDocId: streakBadgeDocId,
    );
  }

  @override
  Future<List<WaterLog>> getWeeklyLogs(
    String uid,
    String start,
    String end,
  ) async {
    final list = await _dataSource.getLogsInRange(uid, start, end);
    return list.map(WaterLogMapper.toDomain).toList();
  }

  @override
  Future<List<WaterLog>> getMonthlyLogs(
    String uid,
    String start,
    String end,
  ) async {
    return getWeeklyLogs(uid, start, end);
  }
}
