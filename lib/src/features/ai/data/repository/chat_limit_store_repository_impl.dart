import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterlogs/src/features/ai/domain/repository/chat_limit_store_repository.dart';

class ChatLimitStoreRepositoryImpl implements ChatLimitStoreRepository {
  static const _prefsPrefix = 'chat_limit';
  static const _countKey = '${_prefsPrefix}_count';
  static const _dateKey = '${_prefsPrefix}_date';

  String _ymd(DateTime n) {
    final y = n.year.toString().padLeft(4, '0');
    final m = n.month.toString().padLeft(2, '0');
    final d = n.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Future<int> getCount() async {
    final p = await SharedPreferences.getInstance();
    final savedDate = p.getString(_dateKey);
    final today = _ymd(DateTime.now());
    if (savedDate != today) {
      return 0;
    }
    return p.getInt(_countKey) ?? 0;
  }

  @override
  Future<void> increase(String today) async {
    final p = await SharedPreferences.getInstance();
    final savedDate = p.getString(_dateKey);

    if (savedDate != today) {
      await p.setInt(_countKey, 1);
      await p.setString(_dateKey, today);
    } else {
      final c = p.getInt(_countKey) ?? 0;
      await p.setInt(_countKey, c + 1);
    }
  }
}
