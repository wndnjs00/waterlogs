import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waterlogs/src/features/account/domain/repository/time_provider.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/auth_provider.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/auth_view_state.dart';
import 'package:waterlogs/src/features/notification/domain/usecase/notification_usecase.dart';
import 'package:waterlogs/src/features/notification/presentation/viewmodel/notification_state.dart';

class NotificationViewModel extends StateNotifier<NotificationState> {
  NotificationViewModel(
    this._ref,
    this._useCase,
    this._timeProvider,
  ) : super(const NotificationState()) {
    // 현재 auth 상태 기준으로 한 번 구독 설정
    final currentAuth = _ref.read(authViewModelProvider);
    _onAuthChanged(currentAuth);

    // 이후 auth 변경될 때마다 다시 설정
    _ref.listen<AuthViewState>(
      authViewModelProvider,
      (prev, next) => _onAuthChanged(next),
    );
  }

  final Ref _ref;
  final NotificationUseCase _useCase;
  final TimeProvider _timeProvider;
  StreamSubscription? _subscription;

  void _onAuthChanged(AuthViewState authState) {
    final uid = authState.user?.uid;
    _subscription?.cancel();

    if (uid != null) {
      _subscription = _useCase.observe(uid).listen(
        (list) => state = state.copyWith(notifications: list),
        onError: (_) =>
            state = state.copyWith(toastMessage: '알림을 불러오지 못했습니다'),
      );
    } else {
      state = state.copyWith(notifications: []);
    }
  }

  Future<void> markAsRead(String id) async {
    final uid = _ref.read(authViewModelProvider).user?.uid;
    if (uid == null) return;
    try {
      await _useCase.markRead(uid, id);
    } catch (_) {
      state = state.copyWith(toastMessage: '알림 읽기 처리 실패');
    }
  }

  String formatTime(String dateTime) {
    return _timeProvider.formatNotificationTime(dateTime);
  }

  void clearToast() {
    state = state.copyWith(toastMessage: null);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
