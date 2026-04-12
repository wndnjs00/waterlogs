abstract class WaterLocalDraftRepository {
  Future<void> saveDraftCups(String uid, String date, int cups);

  Future<int?> loadDraftCups(String uid, String date);

  Future<void> clearDraft(String uid, String date);
}
