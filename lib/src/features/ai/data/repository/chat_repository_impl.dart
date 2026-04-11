import 'package:dio/dio.dart';
import 'package:waterlogs/src/features/ai/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<String> sendQuestion(String question) async {
    final response = await _dio.post<Map<String, dynamic>>(
      'v1/chat/completions',
      data: <String, dynamic>{
        'model': 'gpt-4o-mini',
        'max_tokens': 50,
        'messages': <Map<String, String>>[
          {
            'role': 'system',
            'content':
                '너는 수분 섭취 전문가이자 이를 도와주는 AI야. '
                '물, 커피, 음료 등 수분 섭취와 관련된 질문에만 답해. '
                '수분 섭취와 관련 없는 질문이면 '
                '"수분 섭취와 관련된 질문만 도와드릴 수 있어요 💧"라고 답해. '
                '답변은 반드시 40자 이내로 간결하게 작성해. '
                '불필요한 설명은 하지 마. '
                '카페인 음료는 과다 섭취 시 주의하도록 안내해.',
          },
          {'role': 'user', 'content': question},
        ],
      },
    );

    final data = response.data;
    if (data == null) return '답변을 가져올 수 없습니다';

    final choices = data['choices'];
    if (choices is! List || choices.isEmpty) {
      return '답변을 가져올 수 없습니다';
    }

    final first = choices.first;
    if (first is! Map<String, dynamic>) {
      return '답변을 가져올 수 없습니다';
    }

    final message = first['message'];
    if (message is! Map<String, dynamic>) {
      return '답변을 가져올 수 없습니다';
    }

    final content = message['content'];
    if (content is! String || content.isEmpty) {
      return '답변을 가져올 수 없습니다';
    }

    return content;
  }
}
