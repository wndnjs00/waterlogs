import 'package:waterlogs/src/features/ai/domain/repository/chat_repository.dart';

class SendChatUseCase {
  SendChatUseCase(this._repository);

  final ChatRepository _repository;

  Future<String> call(String question) => _repository.sendQuestion(question);
}
