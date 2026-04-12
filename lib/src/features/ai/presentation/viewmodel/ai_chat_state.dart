import 'package:waterlogs/src/features/ai/domain/model/ai_chat_message.dart';

export 'package:waterlogs/src/features/ai/domain/model/ai_chat_message.dart';

const _toastSentinel = Object();

class AiChatState {
  final List<AiChatMessage> messages;
  final bool isLoading;
  final int count;
  final String? toastMessage;

  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.count = 0,
    this.toastMessage,
  });

  AiChatState copyWith({
    List<AiChatMessage>? messages,
    bool? isLoading,
    int? count,
    Object? toastMessage = _toastSentinel,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      count: count ?? this.count,
      toastMessage: identical(toastMessage, _toastSentinel)
          ? this.toastMessage
          : toastMessage as String?,
    );
  }
}
