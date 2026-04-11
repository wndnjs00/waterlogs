import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waterlogs/src/core/config/app_config.dart';
import 'package:waterlogs/src/core/util/auth_error_mapper.dart';
import 'package:waterlogs/src/features/ai/domain/repository/chat_limit_store_repository.dart';
import 'package:waterlogs/src/features/ai/domain/usecase/send_chat_use_case.dart';
import 'package:waterlogs/src/features/ai/presentation/viewmodel/ai_chat_state.dart';

class AiChatViewModel extends StateNotifier<AiChatState> {
  final SendChatUseCase _sendChatUseCase;
  final ChatLimitStoreRepository _chatLimitStore;

  AiChatViewModel(
    this._sendChatUseCase,
    this._chatLimitStore,
  ) : super(const AiChatState()) {
    Future.microtask(_refreshCount);
  }

  Future<void> _refreshCount() async {
    state = state.copyWith(count: await _chatLimitStore.getCount());
  }

  String _todayString() {
    final n = DateTime.now();
    final y = n.year.toString().padLeft(4, '0');
    final m = n.month.toString().padLeft(2, '0');
    final d = n.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> send(String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty) return;
    if (state.count >= 3) return;

    state = state.copyWith(
      messages: [...state.messages, (isUser: true, text: trimmed)],
      isLoading: true,
    );

    try {
      final answer = await _sendChatUseCase(trimmed);
      state = state.copyWith(
        messages: [...state.messages, (isUser: false, text: answer)],
      );
      await _chatLimitStore.increase(_todayString());
      state = state.copyWith(count: await _chatLimitStore.getCount());
    } catch (e) {
      state = state.copyWith(toastMessage: AuthErrorMapper.map(e));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearToast() {
    state = state.copyWith(toastMessage: null);
  }
}
