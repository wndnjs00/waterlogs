import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;

import '../../domain/model/user_info.dart';
import '../../domain/repository/account_repository.dart';
import '../../domain/repository/time_provider.dart';
import '../mapper/user_info_mapper.dart';
import '../model/user_info_dto.dart';

class AccountRepositoryImpl implements AccountRepository {

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;
  final TimeProvider _timeProvider;

  AccountRepositoryImpl(
    this._auth,
    this._firestore,
    this._functions,
    this._timeProvider,
  );

  final _controller = StreamController<UserInfo?>.broadcast();
  UserInfo? _current;

  static const _collectionUsers = 'users';

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
        .collection(_collectionUsers)
        .doc(withCreatedAt.uid)
        .set(dto.toJson());

    _current = withCreatedAt;
    _controller.add(withCreatedAt);
  }

  @override
  Future<void> logout(LoginProvider? loginProvider) async {
    // TODO: Kotlin 처럼 로그인 공급자별 추가 처리(Google/Kakao/Naver 등)는 추후 플랫폼별 SDK 연동 시 확장
    await _auth.signOut();
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
  Future<UserInfo> signInWithKakao(String accessToken) async {
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
  Future<UserInfo> signInWithNaver(String accessToken) async {
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
  Future<UserInfo> signInWithGoogle(String idToken) async {
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
  @override
  Future<UserInfo?> loadUserFromFireStore() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    final snapshot = await _firestore
        .collection(_collectionUsers)
        .doc(firebaseUser.uid)
        .get();

    if (!snapshot.exists) return null;

    final data = snapshot.data();
    if (data == null) return null;

    final dto = UserInfoDto.fromJson(data);
    final domain = UserInfoMapper.toDomain(dto);

    _current = domain;
    _controller.add(domain);

    return domain;
  }
}