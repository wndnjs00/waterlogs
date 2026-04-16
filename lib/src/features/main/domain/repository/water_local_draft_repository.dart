abstract class WaterLocalDraftRepository {
  /// 임시 저장(클라우드 저장 전) 음료별 ml.
  Future<void> saveDraftBeverages(String uid, String date, Map<String, int> beverages);

  /// 과거 버전(물 cups만 저장)과의 호환을 위해, 구버전 키가 있으면, water ml로 변환해서 반환할 수 있다.
  Future<Map<String, int>?> loadDraftBeverages(String uid, String date);

  Future<void> clearDraft(String uid, String date);
}
