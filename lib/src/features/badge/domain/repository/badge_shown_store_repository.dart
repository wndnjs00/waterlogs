abstract class BadgeShownStoreRepository {
  Future<Set<String>> getShownBadgeKeys(String uid);

  Future<void> saveBadgeKey(String uid, String key);
}
