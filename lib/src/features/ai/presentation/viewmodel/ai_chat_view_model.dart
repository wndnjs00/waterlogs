import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:waterlogs/src/core/util/auth_error_mapper.dart';
import 'package:waterlogs/src/features/ai/domain/repository/ai_chat_local_repository.dart';
import 'package:waterlogs/src/features/ai/domain/repository/chat_limit_store_repository.dart';
import 'package:waterlogs/src/features/ai/domain/usecase/send_chat_use_case.dart';
import 'package:waterlogs/src/features/ai/presentation/viewmodel/ai_chat_state.dart';

class AiChatViewModel extends StateNotifier<AiChatState> {
  final SendChatUseCase _sendChatUseCase;
  final ChatLimitStoreRepository _chatLimitStore;
  final AiChatLocalRepository _localChat;

  AiChatViewModel(
    this._sendChatUseCase,
    this._chatLimitStore,
    this._localChat,
  ) : super(const AiChatState());

  Future<void> refreshFromStorage() async {
    final count = await _chatLimitStore.getCount();
    final messages = await _localChat.loadMessages();
    state = state.copyWith(count: count, messages: messages);
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

    final userMsg = (isUser: true, text: trimmed);
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
    );
    await _localChat.appendMessage(userMsg);

    try {
      final answer = await _sendChatUseCase(trimmed);
      final botMsg = (isUser: false, text: answer);
      state = state.copyWith(
        messages: [...state.messages, botMsg],
      );
      await _localChat.appendMessage(botMsg);
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
