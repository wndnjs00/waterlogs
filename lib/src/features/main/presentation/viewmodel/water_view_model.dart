import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/core/util/auth_error_mapper.dart';
import 'package:waterlogs/src/features/account/domain/repository/time_provider.dart';
import 'package:waterlogs/src/features/main/domain/model/beverage_type.dart';
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
            beverages: const {},
            updatedAt: _timeProvider.nowDateTimeString(),
          );

      final draft = await _draftRepository.loadDraftBeverages(uid, date);
      final serverBeverages = serverLog?.beverages ?? const <String, int>{};

      WaterLog displayLog = base;
      var unsaved = false;

      if (draft != null) {
        if (_sameBeverages(draft, serverBeverages)) {
          await _draftRepository.clearDraft(uid, date);
        } else {
          displayLog = _withDerived(
            base.copyWith(
              beverages: draft,
              updatedAt: _timeProvider.nowDateTimeString(),
            ),
          );
          unsaved = true;
        }
      }

      state = state.copyWith(
        todayLog: _withDerived(displayLog),
        errorMessage: null,
        hasUnsavedChanges: unsaved,
      );
      await _loadWeeklyAndMonthly(uid);
      _syncChartsWithToday(_withDerived(displayLog));
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

    final beverages = Map<String, int>.from(log.beverages);
    final type = state.selectedBeverage;
    final ml = state.servingMl;
    beverages[type.id] = (beverages[type.id] ?? 0) + ml;
    final newLog = _withDerived(
      log.copyWith(
        beverages: beverages,
        updatedAt: _timeProvider.nowDateTimeString(),
      ),
    );
    await _applyLocalChange(newLog);
  }

  Future<void> removeCup() async {
    final log = state.todayLog;
    if (log == null || state.isUpdating) return;

    final beverages = Map<String, int>.from(log.beverages);
    final type = state.selectedBeverage;
    final ml = state.servingMl;
    final current = beverages[type.id] ?? 0;
    if (current <= 0) return;
    beverages[type.id] = (current - ml).clamp(0, 0x7fffffff);
    final newLog = _withDerived(
      log.copyWith(
        beverages: beverages,
        updatedAt: _timeProvider.nowDateTimeString(),
      ),
    );
    await _applyLocalChange(newLog);
  }

  void selectBeverage(BeverageType type, int servingMl) {
    final normalized = servingMl.clamp(50, 2000);
    state = state.copyWith(selectedBeverage: type, servingMl: normalized);
  }

  Future<void> _applyLocalChange(WaterLog newLog) async {
    final uid = _uid;
    if (uid == null) return;

    await _draftRepository.saveDraftBeverages(uid, newLog.date, newLog.beverages);
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
      // 저장 직후 서버에서 오늘기록 다시 읽어와 재동기화
      final serverToday = await _waterUseCase.getToday(uid, log.date);
      final synced = _withDerived(serverToday ?? log);

      state = state.copyWith(
        todayLog: synced,
        isUpdating: false,
        hasUnsavedChanges: false,
      );
      await _loadWeeklyAndMonthly(uid);
      _syncChartsWithToday(synced);
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

  WaterLog _withDerived(WaterLog log) {
    final total = log.beverages.values.fold<int>(0, (s, v) => s + v);
    final waterMl = log.beverages[BeverageType.water.id] ?? 0;
    final cups = waterMl ~/ 250;
    return log.copyWith(totalMl: total, cups: cups);
  }

  bool _sameBeverages(Map<String, int> a, Map<String, int> b) {
    final a2 = Map<String, int>.fromEntries(a.entries.where((e) => e.value > 0));
    final b2 = Map<String, int>.fromEntries(b.entries.where((e) => e.value > 0));
    if (a2.length != b2.length) return false;
    for (final e in a2.entries) {
      if (b2[e.key] != e.value) return false;
    }
    return true;
  }
}
