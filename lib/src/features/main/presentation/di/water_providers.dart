import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/src/features/account/presentation/di/account_providers.dart';
import 'package:waterlogs/src/features/main/data/datasource/water_remote_datasource.dart';
import 'package:waterlogs/src/features/main/data/repository/beverage_unlock_store_impl.dart';
import 'package:waterlogs/src/features/main/data/repository/water_local_draft_repository_impl.dart';
import 'package:waterlogs/src/features/main/data/repository/water_repository_impl.dart';
import 'package:waterlogs/src/features/main/domain/repository/beverage_unlock_store.dart';
import 'package:waterlogs/src/features/main/domain/repository/water_local_draft_repository.dart';
import 'package:waterlogs/src/features/main/domain/repository/water_repository.dart';
import 'package:waterlogs/src/features/main/domain/usecase/water_usecase.dart';
import 'package:waterlogs/src/features/main/presentation/viewmodel/water_view_model.dart';
import 'package:waterlogs/src/features/main/presentation/viewmodel/state/water_view_state.dart';

final waterRemoteDataSourceProvider = Provider<WaterRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return WaterRemoteDataSource(firestore);
});

final waterRepositoryProvider = Provider<WaterRepository>((ref) {
  final dataSource = ref.watch(waterRemoteDataSourceProvider);
  final timeProvider = ref.watch(timeProviderProvider);
  return WaterRepositoryImpl(dataSource, timeProvider);
});

final waterUseCaseProvider = Provider<WaterUseCase>((ref) {
  final repository = ref.watch(waterRepositoryProvider);
  return WaterUseCase(repository);
});

final waterLocalDraftRepositoryProvider = Provider<WaterLocalDraftRepository>(
  (ref) => WaterLocalDraftRepositoryImpl(),
);

final beverageUnlockStoreProvider = Provider<BeverageUnlockStore>(
  (ref) => BeverageUnlockStoreImpl(),
);

final waterViewModelProvider =
    StateNotifierProvider<WaterViewModel, WaterViewState>((ref) {
  final useCase = ref.watch(waterUseCaseProvider);
  final timeProvider = ref.watch(timeProviderProvider);
  final draftRepo = ref.watch(waterLocalDraftRepositoryProvider);
  final unlockStore = ref.watch(beverageUnlockStoreProvider);
  return WaterViewModel(useCase, timeProvider, draftRepo, unlockStore);
});
