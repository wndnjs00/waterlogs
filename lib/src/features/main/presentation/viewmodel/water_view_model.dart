import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/core/util/auth_error_mapper.dart';
import 'package:waterlogs/src/features/account/domain/repository/time_provider.dart';
import 'package:waterlogs/src/features/main/domain/model/water_log.dart';
import 'package:waterlogs/src/features/main/domain/repository/water_local_draft_repository.dart';
import 'package:waterlogs/src/features/main/domain/usecase/water_usecase.dart';
import 'package:waterlogs/src/features/main/presentation/viewmodel/state/water_view_state.dart';

class WaterViewModel extends StateNotifier<WaterViewState> {
  WaterViewModel(this._waterUseCase, this._timeProvider, this._draftRepository)
    : super(const WaterViewState());

  final WaterUseCase _waterUseCase;
  final TimeProvider _timeProvider;
  final WaterLocalDraftRepository _draftRepository;
  String? _uid;

  Future<void> loadToday(String? uid, {int dailyGoal = 8}) async {
    if (uid == null) return;
    _uid = uid;

    try {
      final date = _timeProvider.waterLogDateString();
      final serverLog = await _waterUseCase.getToday(uid, date);

      final base = serverLog ??
          WaterLog(
            date: date,
            cups: 0,
            targetCups: dailyGoal,
            totalMl: 0,
            updatedAt: _timeProvider.nowDateTimeString(),
          );

      final draft = await _draftRepository.loadDraftCups(uid, date);
      final serverCups = serverLog?.cups ?? 0;

      WaterLog displayLog = base;
      var unsaved = false;

      if (draft != null) {
        if (draft == serverCups) {
          await _draftRepository.clearDraft(uid, date);
        } else {
          displayLog = base.copyWith(
            cups: draft,
            totalMl: draft * 250,
            updatedAt: _timeProvider.nowDateTimeString(),
          );
          unsaved = true;
        }
      }

      state = state.copyWith(
        todayLog: displayLog,
        errorMessage: null,
        hasUnsavedChanges: unsaved,
      );
      await _loadWeeklyAndMonthly(uid);
      _syncChartsWithToday(displayLog);
    } catch (e) {
      state = state.copyWith(errorMessage: AuthErrorMapper.mapForWaterUpdate(e));
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
    } catch (_) {}
  }

  void _syncChartsWithToday(WaterLog today) {
    state = state.copyWith(
      weeklyLogs: _mergeTodayInto(state.weeklyLogs, today),
      monthlyLogs: _mergeTodayInto(state.monthlyLogs, today),
    );
  }

  List<WaterLog> _mergeTodayInto(List<WaterLog> logs, WaterLog today) {
    final rest = logs.where((l) => l.date != today.date).toList();
    final merged = [...rest, today]..sort((a, b) => a.date.compareTo(b.date));
    return merged;
  }

  Future<void> addCup() async {
    final log = state.todayLog;
    if (log == null || state.isUpdating) return;

    final newLog = log.copyWith(
      cups: log.cups + 1,
      totalMl: log.totalMl + 250,
      updatedAt: _timeProvider.nowDateTimeString(),
    );
    await _applyLocalChange(newLog);
  }

  Future<void> removeCup() async {
    final log = state.todayLog;
    if (log == null || state.isUpdating || log.cups <= 0) return;

    final newLog = log.copyWith(
      cups: log.cups - 1,
      totalMl: (log.totalMl - 250).clamp(0, 0x7fffffff),
      updatedAt: _timeProvider.nowDateTimeString(),
    );
    await _applyLocalChange(newLog);
  }

  Future<void> _applyLocalChange(WaterLog newLog) async {
    final uid = _uid;
    if (uid == null) return;

    await _draftRepository.saveDraftCups(uid, newLog.date, newLog.cups);
    state = state.copyWith(
      todayLog: newLog,
      hasUnsavedChanges: true,
      errorMessage: null,
    );
    _syncChartsWithToday(newLog);
  }

  Future<void> saveToCloud() async {
    final uid = _uid;
    final log = state.todayLog;
    if (uid == null || log == null || state.isUpdating) return;
    if (!state.hasUnsavedChanges) return;

    state = state.copyWith(isUpdating: true, errorMessage: null);
    try {
      await _waterUseCase.saveWithAchievement(uid, log);
      await _draftRepository.clearDraft(uid, log.date);
      state = state.copyWith(
        todayLog: log,
        isUpdating: false,
        hasUnsavedChanges: false,
      );
      await _loadWeeklyAndMonthly(uid);
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: AuthErrorMapper.mapForWaterUpdate(e),
      );
    }
  }

  /// 저장되지 않은 변경이 있을 때만 Firestore 동기화.
  Future<void> saveToCloudIfNeeded() async {
    if (state.hasUnsavedChanges) {
      await saveToCloud();
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
