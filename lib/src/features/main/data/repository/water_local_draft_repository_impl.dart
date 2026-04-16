import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterlogs/src/features/main/domain/repository/water_local_draft_repository.dart';

class WaterLocalDraftRepositoryImpl implements WaterLocalDraftRepository {
  static String _keyV2(String uid, String date) => 'water_draft_beverages_v2_${uid}_$date';
  static String _keyV1(String uid, String date) => 'water_draft_cups_v1_${uid}_$date';

  @override
  Future<void> saveDraftBeverages(String uid, String date, Map<String, int> beverages) async {
    final p = await SharedPreferences.getInstance();
    final sanitized = Map<String, int>.fromEntries(
      beverages.entries.where((e) => e.value > 0),
    );
    await p.setString(_keyV2(uid, date), jsonEncode(sanitized));
  }

  @override
  Future<Map<String, int>?> loadDraftBeverages(String uid, String date) async {
    final p = await SharedPreferences.getInstance();
    if (p.containsKey(_keyV2(uid, date))) {
      final raw = p.getString(_keyV2(uid, date));
      if (raw == null || raw.trim().isEmpty) return null;
      return _parseJson(raw);
    }

    // v1 호환: cups -> water ml
    if (p.containsKey(_keyV1(uid, date))) {
      final cups = p.getInt(_keyV1(uid, date));
      if (cups == null) return null;
      return {'water': cups * 250};
    }

    return null;
  }

  @override
  Future<void> clearDraft(String uid, String date) async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_keyV2(uid, date));
    await p.remove(_keyV1(uid, date));
  }

  Map<String, int> _parseJson(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return {};
    return decoded.map((k, v) {
      final key = k.toString();
      final value = (v is num) ? v.toInt() : int.tryParse(v.toString()) ?? 0;
      return MapEntry(key, value);
    });
  }
}
