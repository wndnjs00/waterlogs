import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/auth_view_state.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/email_auth_state.dart';

import '../../../domain/model/user_info.dart';
import '../../../domain/repository/account_repository.dart';

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