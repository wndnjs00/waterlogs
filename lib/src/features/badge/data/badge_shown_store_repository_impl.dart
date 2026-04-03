import 'package:shared_preferences/shared_preferences.dart';

import 'package:waterlogs/src/features/badge/domain/repository/badge_shown_store_repository.dart';

class BadgeShownStoreRepositoryImpl implements BadgeShownStoreRepository {
  static const _prefsKey = 'waterlog_badge_shown_keys';

  @override
  Future<Set<String>> getShownBadgeKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_prefsKey) ?? []).toSet();
  }

  @override
  Future<void> saveBadgeKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final next = await getShownBadgeKeys()..add(key);
    await prefs.setStringList(_prefsKey, next.toList());
  }
}
