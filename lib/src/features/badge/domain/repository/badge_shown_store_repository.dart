abstract class BadgeShownStoreRepository {
  Future<Set<String>> getShownBadgeKeys();

  Future<void> saveBadgeKey(String key);
}
