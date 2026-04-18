import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waterlogs/src/core/util/auth_error_mapper.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/auth_provider.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/auth_view_state.dart';
import 'package:waterlogs/src/features/badge/domain/model/badge.dart';
import 'package:waterlogs/src/features/badge/domain/repository/badge_shown_store_repository.dart';
import 'package:waterlogs/src/features/badge/domain/usecase/badge_usecase.dart';
import 'package:waterlogs/src/features/badge/presentation/viewmodel/badge_state.dart';
import 'package:waterlogs/src/features/main/presentation/di/water_providers.dart';

class BadgeViewModel extends StateNotifier<BadgeState> {
  BadgeViewModel(
    this._ref,
    this._useCase,
    this._shownStore,
  ) : super(const BadgeState()) {
    final currentAuth = _ref.read(authViewModelProvider);
    _onAuthChanged(currentAuth);

    _ref.listen<AuthViewState>(
      authViewModelProvider,
      (prev, next) => _onAuthChanged(next),
    );
  }

  final Ref _ref;
  final BadgeUseCase _useCase;
  final BadgeShownStoreRepository _shownStore;
  StreamSubscription<Map<String, Badge>>? _subscription;

  /// [_onAuthChanged]가 연달아 호출될 때 이전 비동기 구독 설정을 무시하기 위함
  int _attachGeneration = 0;

  bool _disposed = false;

  void _onAuthChanged(AuthViewState authState) {
    _subscription?.cancel();
    _subscription = null;

    final uid = authState.user?.uid;
    if (uid == null) {
      state = const BadgeState();
      return;
    }

    final gen = ++_attachGeneration;
    scheduleMicrotask(() => _attachBadgeStream(uid, gen));
  }

  Future<void> _attachBadgeStream(String uid, int gen) async {
    try {
      await _useCase.verifyServerCanLoadBadges(uid);
    } catch (e, _) {
      if (_disposed || gen != _attachGeneration) return;
      if (_ref.read(authViewModelProvider).user?.uid != uid) return;
      state = state.copyWith(
        toastMessage: AuthErrorMapper.mapForBadge(e),
      );
    }

    if (_disposed || gen != _attachGeneration) return;
    if (_ref.read(authViewModelProvider).user?.uid != uid) return;

    _subscription = _useCase.observe(uid).listen(
      _onBadgesSnapshot,
      onError: (e, _) {
        if (_disposed || gen != _attachGeneration) return;
        if (_ref.read(authViewModelProvider).user?.uid != uid) return;
        state = state.copyWith(
          toastMessage: AuthErrorMapper.mapForBadge(e),
        );
      },
    );
  }

  Future<void> _onBadgesSnapshot(Map<String, Badge> map) async {
    final uid = _ref.read(authViewModelProvider).user?.uid;
    if (uid == null) return;

    final shown = await _shownStore.getShownBadgeKeys(uid);
    if (_disposed) return;

    final newQueueKeys = <String>[];

    for (final key in map.keys) {
      if (!shown.contains(key)) {
        await _shownStore.saveBadgeKey(uid, key);
        if (!state.pendingEarnedDialogKeys.contains(key)) {
          newQueueKeys.add(key);
        }
      }
    }

    if (_disposed) return;

    // 대안 A 유지: 항상 관찰하지는 않되(비용 절감),
    // 사용자가 "뱃지 화면"을 열었을 때 새로 감지된 뱃지에 대해서는 음료 잠금도 함께 해제한다.
    if (newQueueKeys.isNotEmpty) {
      await _ref
          .read(waterViewModelProvider.notifier)
          .onBadgeEarnedUnlockForUid(uid, count: newQueueKeys.length);
    }

    state = state.copyWith(
      badges: map,
      pendingEarnedDialogKeys: [
        ...state.pendingEarnedDialogKeys,
        ...newQueueKeys,
      ],
    );
  }

  void dismissCurrentEarnedDialog() {
    if (state.pendingEarnedDialogKeys.isEmpty) return;
    state = state.copyWith(
      pendingEarnedDialogKeys:
          state.pendingEarnedDialogKeys.sublist(1),
    );
  }

  void clearToast() {
    state = state.copyWith(toastMessage: null);
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}
