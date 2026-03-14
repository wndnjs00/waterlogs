import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/features/account/presentation/di/account_providers.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/auth_view_state.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/auth_view_model.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthViewState>((ref) {
      final repository = ref.watch(accountRepositoryProvider);
      final kakaoAuth = ref.watch(kakaoAuthDataSourceProvider);
      final naverAuth = ref.watch(naverAuthDataSourceProvider);
      final googleAuth = ref.watch(googleAuthDataSourceProvider);
      return AuthViewModel(
        repository,
        kakaoAuth: kakaoAuth,
        naverAuth: naverAuth,
        googleAuth: googleAuth,
      );
    });
