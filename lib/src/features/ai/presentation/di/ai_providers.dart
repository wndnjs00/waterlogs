import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waterlogs/src/core/config/app_config.dart';
import 'package:waterlogs/src/features/ai/data/repository/ai_chat_local_repository_impl.dart';
import 'package:waterlogs/src/features/ai/data/repository/chat_limit_store_repository_impl.dart';
import 'package:waterlogs/src/features/ai/data/repository/chat_repository_impl.dart';
import 'package:waterlogs/src/features/ai/domain/repository/ai_chat_local_repository.dart';
import 'package:waterlogs/src/features/ai/domain/repository/chat_limit_store_repository.dart';
import 'package:waterlogs/src/features/ai/domain/repository/chat_repository.dart';
import 'package:waterlogs/src/features/ai/domain/usecase/send_chat_use_case.dart';
import 'package:waterlogs/src/features/ai/presentation/viewmodel/ai_chat_state.dart';
import 'package:waterlogs/src/features/ai/presentation/viewmodel/ai_chat_view_model.dart';

final openAiDioProvider = Provider<Dio>((ref) {
  final apiKey = AppConfig.openAiApiKey;
  final headers = <String, dynamic>{
    'Content-Type': 'application/json',
  };
  if (apiKey != null && apiKey.isNotEmpty) {
    headers['Authorization'] = 'Bearer $apiKey';
  }
  return Dio(
    BaseOptions(
      baseUrl: 'https://api.openai.com/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: headers,
    ),
  );
});

final chatLimitStoreProvider = Provider<ChatLimitStoreRepository>((ref) {
  return ChatLimitStoreRepositoryImpl();
});

final aiChatLocalRepositoryProvider = Provider<AiChatLocalRepository>((ref) {
  return AiChatLocalRepositoryImpl();
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dio = ref.watch(openAiDioProvider);
  return ChatRepositoryImpl(dio);
});

final sendChatUseCaseProvider = Provider<SendChatUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SendChatUseCase(repository);
});

final aiChatViewModelProvider =
    StateNotifierProvider.autoDispose<AiChatViewModel, AiChatState>((ref) {
  return AiChatViewModel(
    ref.watch(sendChatUseCaseProvider),
    ref.watch(chatLimitStoreProvider),
    ref.watch(aiChatLocalRepositoryProvider),
  );
});
