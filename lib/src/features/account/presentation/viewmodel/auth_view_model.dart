import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/user_info.dart';
import '../../domain/repository/account_repository.dart';
import '../di/account_providers.dart';

enum EmailAuthStatus { idle, loading, success, error }

class EmailAuthState {
  const EmailAuthState(this.status, [this.message]);

  final EmailAuthStatus status;
  final String? message;

  static const idle = EmailAuthState(EmailAuthStatus.idle);
  static const loading = EmailAuthState(EmailAuthStatus.loading);
  static const success = EmailAuthState(EmailAuthStatus.success);

  EmailAuthState copyWith({
    EmailAuthStatus? status,
    String? message,
  }) {
    return EmailAuthState(
      status ?? this.status,
      message ?? this.message,
    );
  }
}

class AuthViewState {
  const AuthViewState({
    this.user,
    this.signUpState = EmailAuthState.idle,
    this.signInState = EmailAuthState.idle,
  });

  final UserInfo? user;
  final EmailAuthState signUpState;
  final EmailAuthState signInState;

  AuthViewState copyWith({
    UserInfo? user,
    EmailAuthState? signUpState,
    EmailAuthState? signInState,
  }) {
    return AuthViewState(
      user: user ?? this.user,
      signUpState: signUpState ?? this.signUpState,
      signInState: signInState ?? this.signInState,
    );
  }

  static const initial = AuthViewState();
}


class AuthViewModel extends StateNotifier<AuthViewState> {
  AuthViewModel(this._repository) : super(AuthViewState.initial) {
    _init();
  }

  final AccountRepository _repository;
  StreamSubscription<UserInfo?>? _userSub;

  void _init() {
    // 자동 로그인: Firebase 현재 유저 + Firestore 정보 불러오기
    _repository.loadUserFromFireStore().then((user) {
      if (user != null) {
        state = state.copyWith(user: user);
      }
    });

    _userSub = _repository.getAccountInfo().listen((user) {
      state = state.copyWith(user: user);
    });
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(signUpState: EmailAuthState.loading);
    try {
      await _repository.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );
      state = state.copyWith(signUpState: EmailAuthState.success);
    } catch (e) {
      state = state.copyWith(
        signUpState: EmailAuthState(
          EmailAuthStatus.error,
          e.toString(),
        ),
      );
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(signInState: EmailAuthState.loading);
    try {
      await _repository.signInWithEmail(email: email, password: password);
      state = state.copyWith(signInState: EmailAuthState.success);
    } catch (e) {
      state = state.copyWith(
        signInState: EmailAuthState(
          EmailAuthStatus.error,
          e.toString(),
        ),
      );
    }
  }

  Future<void> logout(LoginProvider? provider) async {
    await _repository.logout(provider);
  }

  void resetSignUpState() {
    state = state.copyWith(signUpState: EmailAuthState.idle);
  }

  void resetSignInState() {
    state = state.copyWith(signInState: EmailAuthState.idle);
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }
}

// 외부에서 사용하는 Provider
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthViewState>((ref) {
  final repository = ref.watch(accountRepositoryProvider);
  return AuthViewModel(repository);
});