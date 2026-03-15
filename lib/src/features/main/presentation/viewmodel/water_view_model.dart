import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/features/account/domain/repository/time_provider.dart';
import 'package:waterlogs/src/features/main/domain/model/water_log.dart';
import 'package:waterlogs/src/features/main/domain/usecase/water_usecase.dart';
import 'package:waterlogs/src/features/main/presentation/viewmodel/state/water_view_state.dart';
class WaterViewModel extends StateNotifier<WaterViewState> {
  final WaterUseCase _waterUseCase;
  final TimeProvider _timeProvider;
  String? _uid;

  WaterViewModel(this._waterUseCase, this._timeProvider)
    : super(const WaterViewState());

  Future<void> loadToday(String? uid, {int dailyGoal = 8}) async {
    if (uid == null) return;
    _uid = uid;

    try {
      final date = _timeProvider.waterLogDateString();
      var log = await _waterUseCase.getToday(uid, date);

      log ??= WaterLog(
          date: date,
          cups: 0,
          targetCups: dailyGoal,
          totalMl: 0,
          updatedAt: _timeProvider.nowDateTimeString(),
        );

      state = state.copyWith(todayLog: log, errorMessage: null);
      await _loadWeeklyAndMonthly(uid);

    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> _loadWeeklyAndMonthly(String uid) async {
    try {
      final startWeek = _timeProvider.weekStart();
      final startMonth = _timeProvider.monthStart();
      final end = _timeProvider.waterLogDateString();

      final weekly = await _waterUseCase.weekly(uid, startWeek, end);
      final monthly = await _waterUseCase.monthly(uid, startMonth, end);

      state = state.copyWith(weeklyLogs: weekly, monthlyLogs: monthly);
    } catch (_) {
    }
  }

  Future<void> addCup() async {
    final log = state.todayLog;
    if (log == null || state.isUpdating) return;

    final newLog = log.copyWith(
      cups: log.cups + 1,
      totalMl: log.totalMl + 250,
      updatedAt: _timeProvider.nowDateTimeString(),
    );
    await _updateLog(newLog);
  }

  Future<void> removeCup() async {
    final log = state.todayLog;
    if (log == null || state.isUpdating || log.cups <= 0) return;

    final newLog = log.copyWith(
      cups: log.cups - 1,
      totalMl: (log.totalMl - 250).clamp(0, 0x7fffffff),
      updatedAt: _timeProvider.nowDateTimeString(),
    );
    await _updateLog(newLog);
  }

  Future<void> _updateLog(WaterLog newLog) async {
    final uid = _uid;
    if (uid == null) return;

    state = state.copyWith(isUpdating: true, errorMessage: null);
    try {
      await _waterUseCase.saveWithAchievement(uid, newLog);
      state = state.copyWith(todayLog: newLog, isUpdating: false);
      await _loadWeeklyAndMonthly(uid);
    } catch (e) {
      state = state.copyWith(isUpdating: false, errorMessage: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
