import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/account_repository_impl.dart';
import '../../data/repository/time_provider_impl.dart';
import '../../domain/repository/account_repository.dart';
import '../../domain/repository/time_provider.dart';

// FirebaseAuth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// FirebaseFirestore
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// TimeProvider
final timeProviderProvider = Provider<TimeProvider>((ref) {
  return const TimeProviderImpl();
});

// AccountRepository
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  final timeProvider = ref.watch(timeProviderProvider);
  return AccountRepositoryImpl(auth, firestore, timeProvider);
});