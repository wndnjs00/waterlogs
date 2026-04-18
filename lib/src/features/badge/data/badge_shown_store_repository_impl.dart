import 'package:shared_preferences/shared_preferences.dart';

import 'package:waterlogs/src/features/badge/domain/repository/badge_shown_store_repository.dart';

class BadgeShownStoreRepositoryImpl implements BadgeShownStoreRepository {
  // legacy(전역) 키: 초기 구현에서 계정 구분이 없어 공유되던 값
  static const _legacyPrefsKey = 'waterlog_badge_shown_keys';

  @override
  Future<Set<String>> getShownBadgeKeys(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = _userKey(uid);

    // 마이그레이션: per-user 값이 아직 없고, legacy가 있으면 현재 uid로 1회 이전
    if (!prefs.containsKey(userKey) && prefs.containsKey(_legacyPrefsKey)) {
      final legacy = (prefs.getStringList(_legacyPrefsKey) ?? []).toSet();
      await prefs.setStringList(userKey, legacy.toList());
      await prefs.remove(_legacyPrefsKey);
      return legacy;
    }

    return (prefs.getStringList(userKey) ?? []).toSet();
  }

  @override
  Future<void> saveBadgeKey(String uid, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final next = await getShownBadgeKeys(uid)..add(key);
    await prefs.setStringList(_userKey(uid), next.toList());
  }

  String _userKey(String uid) => 'waterlog_uid:$uid:badge_shown_keys';
}
