import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/core/util/auth_error_mapper.dart';
import 'package:waterlogs/src/features/account/domain/usecase/account_usecase.dart';
import 'package:waterlogs/src/features/account/domain/usecase/auth_usecase.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/auth_view_state.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/email_auth_state.dart';

import '../../data/datasource/google_auth_datasource.dart';
import '../../data/datasource/kakao_auth_datasource.dart';
import '../../data/datasource/naver_auth_datasource.dart';
import '../../domain/model/user_info.dart';
import '../../domain/repository/account_repository.dart';

class AuthViewModel extends StateNotifier<AuthViewState> {

  final AuthUseCase _authUseCase;
  final AccountUseCase _accountUseCase;

  StreamSubscription<UserInfo?>? _userSub;

  AuthViewModel(
      this._authUseCase,
      this._accountUseCase,
      ): super(AuthViewState.initial) {
    _init();
  }

  void _init() {
    // 자동 로그인: Firebase 현재 유저 + Firestore 정보 불러오기
    _accountUseCase.loadUser().then((user) {
      if (user != null) {
        state = state.copyWith(user: user);
      }
    }).catchError((e) async {
      state = state.copyWith(toastMessage: AuthErrorMapper.map(e));
      // Auth 세션은 있는데 Firestore 문서 없음 (불일치 시) → 로그아웃하여 로그인 화면에서 재시도 가능하게
      await _accountUseCase.logout(null);
    });

    _userSub = _accountUseCase.getAccountInfo().listen((user) {
      state = state.copyWith(user: user);
    });
  }

  void clearToast() {
    state = state.copyWith(toastMessage: null);
  }

  // OAuth(Google/Kakao/Naver) 로그인 실패 시 토스트 메시지
  void showOAuthError(Object e) {
    state = state.copyWith(toastMessage: AuthErrorMapper.mapForOAuth(e));
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(signUpState: EmailAuthState.loading);

    try {
      await _authUseCase.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );

      state = state.copyWith(signUpState: EmailAuthState.success);
    } catch (e) {
      final msg = AuthErrorMapper.map(e);
      state = state.copyWith(
        signUpState: EmailAuthState(
          status: EmailAuthStatus.error,
          message: msg,
        ),
        toastMessage: msg,
      );
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(signInState: EmailAuthState.loading);

    try {
      await _authUseCase.signInWithEmail(email: email, password: password);

      state = state.copyWith(signInState: EmailAuthState.success);

    } catch (e) {
      final msg = AuthErrorMapper.map(e);
      state = state.copyWith(
        signInState: EmailAuthState(
          status: EmailAuthStatus.error,
          message: msg,
        ),
        toastMessage: msg,
      );
    }
  }

  Future<void> logout(LoginProvider? provider) async {
    try {
      await _accountUseCase.logout(provider);
      state = state.copyWith(toastMessage: '로그아웃 되었습니다');
    } catch (e) {
      state = state.copyWith(toastMessage: AuthErrorMapper.map(e));
    }
  }

  Future<void> signInWithKakao() async {
    await _authUseCase.signInWithKakao();
  }

  // 네이버 로그인
  Future<void> signInWithNaver() async {
    await _authUseCase.signInWithNaver();
  }

  // 구글 로그인
  Future<void> signInWithGoogle() async {
    await _authUseCase.signInWithGoogle();
  }

  void resetSignUpState() {
    state = state.copyWith(signUpState: EmailAuthState.idle);
  }

  void resetSignInState() {
    state = state.copyWith(signInState: EmailAuthState.idle);
  }

  Future<void> deleteAccount(
      LoginProvider provider, {
        String? emailReauthPassword,
      }) async {
    try {
      await _accountUseCase.deleteAccount(
        provider,
        emailReauthPassword: emailReauthPassword,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }
}