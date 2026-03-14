import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/core/config/app_config.dart';

import '../../data/datasource/google_auth_datasource.dart';
import '../../data/datasource/kakao_auth_datasource.dart';
import '../../data/datasource/naver_auth_datasource.dart';
import '../../data/repository/account_repository_impl.dart';
import '../../data/repository/time_provider_impl.dart';
import '../../domain/repository/account_repository.dart';
import '../../domain/repository/time_provider.dart';

// Firebase
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final firebaseFunctionsProvider = Provider<FirebaseFunctions>((ref) => FirebaseFunctions.instance);

// TimeProvider
final timeProviderProvider = Provider<TimeProvider>((ref) => const TimeProviderImpl());

// Social login data sources
final kakaoAuthDataSourceProvider = Provider<KakaoAuthDataSource>((ref) => KakaoAuthDataSource());
final naverAuthDataSourceProvider = Provider<NaverAuthDataSource>((ref) => NaverAuthDataSource());

final googleAuthDataSourceProvider = Provider<GoogleAuthDataSource>((ref) {
  return GoogleAuthDataSource(serverClientId: AppConfig.googleServerClientId);
});

// AccountRepository
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  final functions = ref.watch(firebaseFunctionsProvider);
  final timeProvider = ref.watch(timeProviderProvider);
  return AccountRepositoryImpl(auth, firestore, functions, timeProvider);
});