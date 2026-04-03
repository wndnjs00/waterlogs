import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waterlogs/src/features/account/presentation/viewmodel/auth_provider.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/auth_view_state.dart';
import 'package:waterlogs/src/features/badge/domain/model/badge.dart';
import 'package:waterlogs/src/features/badge/domain/repository/badge_shown_store_repository.dart';
import 'package:waterlogs/src/features/badge/domain/usecase/badge_usecase.dart';
import 'package:waterlogs/src/features/badge/presentation/viewmodel/badge_state.dart';

class BadgeViewModel extends StateNotifier<BadgeState> {
  final Ref _ref;
  final BadgeUseCase _useCase;
  final BadgeShownStoreRepository _shownStore;
  StreamSubscription<Map<String, Badge>>? _subscription;

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

  void _onAuthChanged(AuthViewState authState) {
    _subscription?.cancel();
    _subscription = null;

    final uid = authState.user?.uid;
    if (uid == null) {
      state = const BadgeState();
      return;
    }

    _subscription = _useCase.observe(uid).listen(
      _onBadgesSnapshot,
      onError: (_) {},
    );
  }

  Future<void> _onBadgesSnapshot(Map<String, Badge> map) async {
    final shown = await _shownStore.getShownBadgeKeys();
    final newQueueKeys = <String>[];

    for (final key in map.keys) {
      if (!shown.contains(key)) {
        await _shownStore.saveBadgeKey(key);
        if (!state.pendingEarnedDialogKeys.contains(key)) {
          newQueueKeys.add(key);
        }
      }
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
