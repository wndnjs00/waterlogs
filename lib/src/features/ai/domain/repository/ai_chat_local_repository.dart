import 'package:waterlogs/src/features/ai/domain/model/ai_chat_message.dart';

abstract class AiChatLocalRepository {
  Future<List<AiChatMessage>> loadMessages();

  Future<void> appendMessage(AiChatMessage message);
}