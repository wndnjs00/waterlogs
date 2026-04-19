import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/core/crashlytics/app_crashlytics.dart';
import 'package:waterlogs/src/core/util/auth_error_mapper.dart';
import 'package:waterlogs/src/features/account/domain/repository/time_provider.dart';
import 'package:waterlogs/src/features/main/domain/model/beverage_type.dart';
import 'package:waterlogs/src/features/main/domain/repository/beverage_unlock_store.dart';
import 'package:waterlogs/src/features/main/domain/model/water_log.dart';
import 'package:waterlogs/src/features/main/domain/repository/water_local_draft_repository.dart';
import 'package:waterlogs/src/features/main/domain/usecase/water_usecase.dart';
import 'package:waterlogs/src/features/main/presentation/viewmodel/state/water_view_state.dart';

class WaterViewModel extends StateNotifier<WaterViewState> {
  WaterViewModel(
    this._waterUseCase,
    this._timeProvider,
    this._draftRepository,
    this._unlockStore,
  )
    : super(const WaterViewState());

  final WaterUseCase _waterUseCase;
  final TimeProvider _timeProvider;
  final WaterLocalDraftRepository _draftRepository;
  final BeverageUnlockStore _unlockStore;
  String? _uid;

  Future<void> loadToday(String? uid, {int dailyGoal = 8}) async {
    if (uid == null) return;
    _uid = uid;

    try {
      await AppCrashlytics.log('water:load_today_start');
      final unlock = await _unlockStore.load(uid);
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
        unlockedPremiumBeverageCount: unlock.unlockedPremiumCount,
        rewardedAdProgress: unlock.rewardedProgress,
      );
      final derived = _withDerived(displayLog);
      await AppCrashlytics.syncWaterSession(
        logDate: date,
        cups: derived.cups,
        hasUnsavedDraft: unsaved,
      );
      await AppCrashlytics.log('water:load_today_ok');
      await _loadWeeklyAndMonthly(uid);
      _syncChartsWithToday(derived);
    } catch (e, st) {
      await AppCrashlytics.log('water:load_today_err');
      await AppCrashlytics.recordHandledError(
        e,
        st,
        reason: 'loadToday',
      );
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
    if (isBeverageLocked(type)) return;
    final normalized = servingMl.clamp(50, 2000);
    state = state.copyWith(selectedBeverage: type, servingMl: normalized);
  }

  static const _premiumOrder = <BeverageType>[
    BeverageType.coffee,
    BeverageType.juice,
    BeverageType.soda,
    BeverageType.milk,
  ];

  bool isBeverageLocked(BeverageType type) {
    final idx = _premiumOrder.indexOf(type);
    if (idx < 0) return false; // water, tea는 잠금 없음
    return idx >= state.unlockedPremiumBeverageCount;
  }

  Future<void> onRewardedAdEarned() async {
    final uid = _uid;
    if (uid == null) return;
    final next = await _unlockStore.onRewardedAdEarned(uid);
    state = state.copyWith(
      unlockedPremiumBeverageCount: next.unlockedPremiumCount,
      rewardedAdProgress: next.rewardedProgress,
    );
  }

  Future<void> onBadgeEarnedUnlock({int count = 1}) async {
    final uid = _uid;
    if (uid == null) return;
    final next = await _unlockStore.onBadgeEarned(uid, count: count);
    state = state.copyWith(
      unlockedPremiumBeverageCount: next.unlockedPremiumCount,
      rewardedAdProgress: next.rewardedProgress,
    );
  }

  /// 뱃지 획득 해금은 "현재 화면에서 물 기능이 아직 로드 전"이어도 발생할 수 있어서,
  /// uid를 직접 받아 처리할 수 있는 엔트리 포인트를 따로 둔다.
  Future<void> onBadgeEarnedUnlockForUid(String uid, {int count = 1}) async {
    final next = await _unlockStore.onBadgeEarned(uid, count: count);

    // uid별 저장을 쓰는 값이므로, 호출한 쪽이 현재 유저 uid라고 가정하고 항상 UI 상태도 동기화한다.
    state = state.copyWith(
      unlockedPremiumBeverageCount: next.unlockedPremiumCount,
      rewardedAdProgress: next.rewardedProgress,
    );
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
    unawaited(
      AppCrashlytics.syncWaterSession(
        logDate: newLog.date,
        cups: newLog.cups,
        hasUnsavedDraft: true,
      ),
    );
    unawaited(
      AppCrashlytics.log(
        'water:draft_changed totalMl=${newLog.totalMl} cups=${newLog.cups}',
      ),
    );
  }

  Future<void> saveToCloud() async {
    final uid = _uid;
    final log = state.todayLog;
    if (uid == null || log == null || state.isUpdating) return;
    if (!state.hasUnsavedChanges) return;

    state = state.copyWith(isUpdating: true, errorMessage: null);
    await AppCrashlytics.log('water:save_cloud_start');
    await AppCrashlytics.setCustomKey('water_saving', true);
    try {
      final newBadges = await _waterUseCase.saveWithAchievement(uid, log);
      await _draftRepository.clearDraft(uid, log.date);

      // 대안 A: "이번 저장에서 새로 획득된 뱃지 수"만큼 음료 해금
      if (newBadges > 0) {
        await onBadgeEarnedUnlockForUid(uid, count: newBadges);
      }

      // 저장 직후 서버에서 오늘기록 다시 읽어와 재동기화
      final serverToday = await _waterUseCase.getToday(uid, log.date);
      final synced = _withDerived(serverToday ?? log);

      state = state.copyWith(
        todayLog: synced,
        isUpdating: false,
        hasUnsavedChanges: false,
      );
      await AppCrashlytics.setCustomKey('water_saving', false);
      await AppCrashlytics.syncWaterSession(
        logDate: synced.date,
        cups: synced.cups,
        hasUnsavedDraft: false,
      );
      await AppCrashlytics.log('water:save_cloud_ok');
      await _loadWeeklyAndMonthly(uid);
      _syncChartsWithToday(synced);
    } catch (e, st) {
      await AppCrashlytics.setCustomKey('water_saving', false);
      await AppCrashlytics.log('water:save_cloud_err');
      await AppCrashlytics.recordHandledError(
        e,
        st,
        reason: 'saveToCloud',
      );
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
