import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/auth_view_state.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/email_auth_state.dart';

import '../../data/datasource/google_auth_datasource.dart';
import '../../data/datasource/kakao_auth_datasource.dart';
import '../../data/datasource/naver_auth_datasource.dart';
import '../../domain/model/user_info.dart';
import '../../domain/repository/account_repository.dart';

class AuthViewModel extends StateNotifier<AuthViewState> {

  final AccountRepository _repository;
  final KakaoAuthDataSource _kakaoAuth;
  final NaverAuthDataSource _naverAuth;
  final GoogleAuthDataSource _googleAuth;
  StreamSubscription<UserInfo?>? _userSub;

  AuthViewModel(
    this._repository, {
    required KakaoAuthDataSource kakaoAuth,
    required NaverAuthDataSource naverAuth,
    required GoogleAuthDataSource googleAuth,
  })  : _kakaoAuth = kakaoAuth,
        _naverAuth = naverAuth,
        _googleAuth = googleAuth,
        super(AuthViewState.initial) {
    _init();
  }

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
    switch (provider) {
      case LoginProvider.kakao:
        await _kakaoAuth.logout();
        break;
      case LoginProvider.naver:
        await _naverAuth.logout();
        break;
      case LoginProvider.google:
        await _googleAuth.logout();
        break;
      case LoginProvider.email:
      case null:
        break;
    }
    await _repository.logout(provider);
  }

  Future<void> signInWithKakao() async {
    final accessToken = await _kakaoAuth.getAccessToken();
    await _repository.signInWithKakao(accessToken);
  }

  // 네이버 로그인
  Future<void> signInWithNaver() async {
    final accessToken = await _naverAuth.getAccessToken();
    await _repository.signInWithNaver(accessToken);
  }

  // 구글 로그인
  Future<void> signInWithGoogle() async {
    final idToken = await _googleAuth.getIdToken();
    await _repository.signInWithGoogle(idToken);
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