import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterlogs/src/features/main/domain/repository/water_local_draft_repository.dart';

class WaterLocalDraftRepositoryImpl implements WaterLocalDraftRepository {
  static String _key(String uid, String date) => 'water_draft_cups_v1_${uid}_$date';

  @override
  Future<void> saveDraftCups(String uid, String date, int cups) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_key(uid, date), cups);
  }

  @override
  Future<int?> loadDraftCups(String uid, String date) async {
    final p = await SharedPreferences.getInstance();
    if (!p.containsKey(_key(uid, date))) return null;
    return p.getInt(_key(uid, date));
  }

  @override
  Future<void> clearDraft(String uid, String date) async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_key(uid, date));
  }
}
