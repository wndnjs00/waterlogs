import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waterlogs/src/features/account/presentation/di/account_providers.dart';
import 'package:waterlogs/src/features/badge/data/badge_shown_store_repository_impl.dart';
import 'package:waterlogs/src/features/badge/data/repository/badge_repository_impl.dart';
import 'package:waterlogs/src/features/badge/domain/repository/badge_repository.dart';
import 'package:waterlogs/src/features/badge/domain/repository/badge_shown_store_repository.dart';
import 'package:waterlogs/src/features/badge/domain/usecase/badge_usecase.dart';
import 'package:waterlogs/src/features/badge/presentation/viewmodel/badge_state.dart';
import 'package:waterlogs/src/features/badge/presentation/viewmodel/badge_view_model.dart';

final badgeShownStoreProvider = Provider<BadgeShownStoreRepository>((ref) {
  return BadgeShownStoreRepositoryImpl();
});

final badgeRepositoryProvider = Provider<BadgeRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return BadgeRepositoryImpl(firestore);
});

final badgeUseCaseProvider = Provider<BadgeUseCase>((ref) {
  final repository = ref.watch(badgeRepositoryProvider);
  return BadgeUseCase(repository);
});

final badgeViewModelProvider =
    StateNotifierProvider.autoDispose<BadgeViewModel, BadgeState>((ref) {
  return BadgeViewModel(
    ref,
    ref.watch(badgeUseCaseProvider),
    ref.watch(badgeShownStoreProvider),
  );
});
