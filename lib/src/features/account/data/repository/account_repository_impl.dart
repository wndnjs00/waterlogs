import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;
import 'package:waterlogs/src/core/util/firestore_paths.dart';

import '../../domain/model/user_info.dart';
import '../../domain/repository/account_repository.dart';
import '../../domain/repository/time_provider.dart';
import '../datasource/account_remote_datasource.dart';
import '../datasource/google_auth_datasource.dart';
import '../datasource/kakao_auth_datasource.dart';
import '../datasource/naver_auth_datasource.dart';
import '../mapper/user_info_mapper.dart';
import '../model/user_info_dto.dart';

class AccountRepositoryImpl implements AccountRepository {

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;
  final TimeProvider _timeProvider;
  final AccountRemoteDataSource _accountRemote;
  final KakaoAuthDataSource _kakaoAuth;
  final NaverAuthDataSource _naverAuth;
  final GoogleAuthDataSource _googleAuth;

  AccountRepositoryImpl(
    this._auth,
    this._firestore,
    this._functions,
    this._timeProvider,
    this._accountRemote,
    this._kakaoAuth,
    this._naverAuth,
    this._googleAuth,
  );

  final _controller = StreamController<UserInfo?>.broadcast();
  UserInfo? _current;

  @override
  Stream<UserInfo?> getAccountInfo() => _controller.stream;

  // Firestore에 사용자 정보 저장
  @override
  Future<void> saveUserInfo(UserInfo userInfo) async {
    final withCreatedAt = userInfo.createdAt == null
        ? userInfo.copyWith(createdAt: _timeProvider.nowDateTimeString())
        : userInfo;

    final dto = UserInfoMapper.toDto(withCreatedAt);

    await _firestore
        .collection(FirestorePaths.users)
        .doc(withCreatedAt.uid)
        .set(dto.toJson());

    await _createWelcomeNotificationIfNeeded(withCreatedAt.uid, withCreatedAt.name);

    _current = withCreatedAt;
    _controller.add(withCreatedAt);
  }

  // 첫 로그인/저장 시 welcome 알림
  Future<void> _createWelcomeNotificationIfNeeded(String uid, String name) async {
    final notificationsRef = _firestore
        .collection(FirestorePaths.users)
        .doc(uid)
        .collection(FirestorePaths.notifications);

    final snapshot = await notificationsRef
        .where('type', isEqualTo: 'welcome')
        .get();

    if (snapshot.docs.isEmpty) {
      await notificationsRef.doc().set({
        'title': '환영합니다 ${name}님 🎉',
        'message': 'WaterLog와 함께 건강한 수분습관을 시작해보세요!',
        'type': 'welcome',
        'createdAt': _timeProvider.nowDateTimeString(),
        'isRead': false,
      });
    }
  }

  @override
  Future<void> logout(LoginProvider? loginProvider) async {
    
    switch (loginProvider) {
      case LoginProvider.google:
        await _googleAuth.logout();
        break;
      case LoginProvider.kakao:
        await _kakaoAuth.logout();
        break;
      case LoginProvider.naver:
        await _naverAuth.logout();
        break;
      case LoginProvider.email:
      case null:
        break;
    }
    await _auth.signOut();
    _current = null;
    _controller.add(null);
  }

  @override
  Future<void> deleteAccount(
    LoginProvider loginProvider, {
    String? emailReauthPassword,
  }) async {
    final uid = _accountRemote.getCurrentUserId();
    
    if (uid == null) {
      throw StateError('user not logged in');
    }

    switch (loginProvider) {
      case LoginProvider.kakao:
        await _kakaoAuth.signout();
        break;
      case LoginProvider.naver:
        await _naverAuth.signout();
        break;
      case LoginProvider.google:
        await _googleAuth.logout();
        break;
      case LoginProvider.email:
        final email = _accountRemote.getCurrentUserEmail();
        if (email == null || email.isEmpty) {
          throw StateError('이메일 정보가 없습니다');
        }

        final password = emailReauthPassword ?? (throw StateError('이메일 회원탈퇴 시 비밀번호가 필요합니다'));
        await _accountRemote.reauthenticateWithEmail(email: email, password: password);
        break;
    }

    await _accountRemote.deleteUserDocument(uid);
    await _accountRemote.deleteCurrentUser();

    _current = null;
    _controller.add(null);
  }

  @override
  Future<UserInfo> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = result.user;

    if (user == null) {
      throw StateError('User is null after signUpWithEmail');
    }

    final userInfo = UserInfo(
      uid: user.uid,
      name: name,
      email: user.email ?? email,
      loginProvider: LoginProvider.email,
      createdAt: _timeProvider.nowDateTimeString(),
    );

    // Firestore에 사용자 정보를 저장
    await saveUserInfo(userInfo);
    return userInfo;
  }

  @override
  Future<UserInfo> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);

    final userInfo = await loadUserFromFireStore();
    if (userInfo == null) {
      throw StateError('Firestore user not found');
    }
    return userInfo;
  }

  @override
  Future<UserInfo> signInWithKakao() async {

    final accessToken = await _kakaoAuth.getAccessToken();

    final result = await _functions
        .httpsCallable('createCustomTokenWithKakao')
        .call({'accessToken': accessToken});

    final data = result.data as Map<String, dynamic>?;

    if (data == null) {
      throw StateError('Cloud Function returned null');
    }

    final customToken = data['customToken'] as String?;
    final uid = data['uid'] as String?;
    final nickname = data['nickname'] as String?;
    final email = data['email'] as String?;

    if (customToken == null || uid == null || nickname == null) {
      throw StateError('Invalid response from createCustomTokenWithKakao');
    }

    await _auth.signInWithCustomToken(customToken);

    final userInfo = UserInfo(
      uid: uid,
      name: nickname,
      email: email,
      loginProvider: LoginProvider.kakao,
      createdAt: _timeProvider.nowDateTimeString(),
    );

    // Firestore에 사용자 정보를 저장
    await saveUserInfo(userInfo);
    return userInfo;
  }

  @override
  Future<UserInfo> signInWithNaver() async {

    final accessToken = await _naverAuth.getAccessToken();

    final result = await _functions
        .httpsCallable('createCustomTokenWithNaver')
        .call({'accessToken': accessToken});

    final data = result.data as Map<String, dynamic>?;

    if (data == null) {
      throw StateError('Cloud Function returned null');
    }

    final customToken = data['customToken'] as String?;
    final uid = data['uid'] as String?;
    final nickname = data['nickname'] as String?;
    final email = data['email'] as String?;

    if (customToken == null || uid == null || nickname == null) {
      throw StateError('Invalid response from createCustomTokenWithNaver');
    }

    await _auth.signInWithCustomToken(customToken);

    final userInfo = UserInfo(
      uid: uid,
      name: nickname,
      email: email ?? '',
      loginProvider: LoginProvider.naver,
      createdAt: _timeProvider.nowDateTimeString(),
    );

    // Firestore에 사용자 정보를 저장
    await saveUserInfo(userInfo);
    return userInfo;
  }

  @override
  Future<UserInfo> signInWithGoogle() async {
    final idToken = await _googleAuth.getIdToken();
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    await _auth.signInWithCredential(credential);

    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('Firebase user is null after Google sign-in');
    }

    final userInfo = UserInfo(
      uid: user.uid,
      name: user.displayName ?? '닉네임없음',
      email: user.email,
      loginProvider: LoginProvider.google,
      createdAt: _timeProvider.nowDateTimeString(),
    );

    // Firestore에 사용자 정보를 저장
    await saveUserInfo(userInfo);
    return userInfo;
  }

  // 자동 로그인용: 저장된 사용자 정보 로드
  // Auth 세션은 있는데 Firestore 사용자 문서가 없으면 예외 발생 (불일치 상태 방지 → '토큰 문제' 처리)
  @override
  Future<UserInfo?> loadUserFromFireStore() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    final snapshot = await _firestore
        .collection(FirestorePaths.users)
        .doc(firebaseUser.uid)
        .get();

    if (!snapshot.exists) {
      throw FirebaseAuthException(
        code: 'user-token-mismatch',
        message: 'Firestore user document not found for current auth user',
      );
    }

    final data = snapshot.data();
    if (data == null) {
      throw FirebaseAuthException(
        code: 'user-token-mismatch',
        message: 'Firestore user data is null',
      );
    }

    final dto = UserInfoDto.fromJson(data);
    final domain = UserInfoMapper.toDomain(dto);

    _current = domain;
    _controller.add(domain);

    return domain;
  }

  @override
  Future<void> saveFcmToken(String token) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userRef = _firestore
        .collection(FirestorePaths.users)
        .doc(user.uid);

    final snapshot = await userRef.get();
    final data = snapshot.data();
    final existingToken = data != null ? data['fcmToken'] as String? : null;

    await userRef.update({'fcmToken': token});

    // 최초 토큰 저장 시 welcome 알림을 보장
    if (existingToken == null) {
      final name = data != null ? data['name'] as String? ?? 'waterLog' : 'waterLog';
      await _createWelcomeNotificationIfNeeded(user.uid, name);
    }
  }
}