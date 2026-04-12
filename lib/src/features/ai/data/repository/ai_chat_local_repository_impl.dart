import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterlogs/src/features/ai/domain/model/ai_chat_message.dart';
import 'package:waterlogs/src/features/ai/domain/repository/ai_chat_local_repository.dart';

class AiChatLocalRepositoryImpl implements AiChatLocalRepository {
  static const _messagesKey = 'ai_chat_messages_json';

  List<Map<String, dynamic>> _decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<AiChatMessage>> loadMessages() async {
    final p = await SharedPreferences.getInstance();
    final rows = _decodeList(p.getString(_messagesKey));
    return rows
        .map(
          (r) => (
            isUser: r['isUser'] == true,
            text: r['text'] as String? ?? '',
          ),
        )
        .toList();
  }

  @override
  Future<void> appendMessage(AiChatMessage message) async {
    final p = await SharedPreferences.getInstance();
    final list = _decodeList(p.getString(_messagesKey));
    list.add({
      'isUser': message.isUser,
      'text': message.text,
    });
    await p.setString(_messagesKey, jsonEncode(list));
  }
}
