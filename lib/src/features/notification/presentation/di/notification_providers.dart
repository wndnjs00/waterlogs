import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waterlogs/src/features/account/presentation/di/account_providers.dart';
import 'package:waterlogs/src/features/notification/data/repository/notification_repository_impl.dart';
import 'package:waterlogs/src/features/notification/domain/repository/notification_repository.dart';
import 'package:waterlogs/src/features/notification/domain/usecase/notification_usecase.dart';
import 'package:waterlogs/src/features/notification/presentation/viewmodel/notification_view_model.dart';
import 'package:waterlogs/src/features/notification/presentation/viewmodel/notification_state.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return NotificationRepositoryImpl(firestore);
});

final notificationUseCaseProvider = Provider<NotificationUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationUseCase(repository);
});

final notificationViewModelProvider =
    StateNotifierProvider<NotificationViewModel, NotificationState>((ref) {
  final useCase = ref.watch(notificationUseCaseProvider);
  final timeProvider = ref.watch(timeProviderProvider);
  return NotificationViewModel(ref, useCase, timeProvider);
});
