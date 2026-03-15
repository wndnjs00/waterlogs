import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/core/config/app_config.dart';
import 'package:waterlogs/src/features/account/domain/usecase/account_usecase.dart';
import 'package:waterlogs/src/features/account/domain/usecase/auth_usecase.dart';

import '../../data/datasource/account_remote_datasource.dart';
import '../../data/datasource/google_auth_datasource.dart';
import '../../data/datasource/kakao_auth_datasource.dart';
import '../../data/datasource/naver_auth_datasource.dart';
import '../../data/repository/account_repository_impl.dart';
import '../../data/repository/time_provider_impl.dart';
import '../../domain/repository/account_repository.dart';
import '../../domain/repository/time_provider.dart';

// Firebase
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final firebaseFunctionsProvider = Provider<FirebaseFunctions>(
  (ref) => FirebaseFunctions.instance,
);

// TimeProvider
final timeProviderProvider = Provider<TimeProvider>(
  (ref) => const TimeProviderImpl(),
);

// Social login data sources
final kakaoAuthDataSourceProvider = Provider<KakaoAuthDataSource>(
  (ref) => KakaoAuthDataSource(),
);

final naverAuthDataSourceProvider = Provider<NaverAuthDataSource>(
  (ref) => NaverAuthDataSource(),
);

final googleAuthDataSourceProvider = Provider<GoogleAuthDataSource>((ref) {
  return GoogleAuthDataSource(serverClientId: AppConfig.googleServerClientId);
});

// Remote datasource
final accountRemoteDataSourceProvider = Provider<AccountRemoteDataSource>((ref,) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  return AccountRemoteDataSource(auth, firestore);
});

// AccountRepository
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  final functions = ref.watch(firebaseFunctionsProvider);
  final timeProvider = ref.watch(timeProviderProvider);
  final accountRemote = ref.watch(accountRemoteDataSourceProvider);
  final kakaoAuth = ref.watch(kakaoAuthDataSourceProvider);
  final naverAuth = ref.watch(naverAuthDataSourceProvider);
  final googleAuth = ref.watch(googleAuthDataSourceProvider);
  return AccountRepositoryImpl(
    auth,
    firestore,
    functions,
    timeProvider,
    accountRemote,
    kakaoAuth,
    naverAuth,
    googleAuth,
  );
});

// AuthUseCase (로그인 / 회원가입)
final authUseCaseProvider = Provider<AuthUseCase>((ref) {
  final repository = ref.watch(accountRepositoryProvider);
  return AuthUseCase(repository);
});

// AccountUseCase (로그아웃 / 회원탈퇴 / 자동로그인)
final accountUseCaseProvider = Provider<AccountUseCase>((ref) {
  final repository = ref.watch(accountRepositoryProvider);
  return AccountUseCase(repository);
});
