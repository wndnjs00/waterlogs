import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterlogs/src/features/main/domain/model/beverage_unlock_data.dart';
import 'package:waterlogs/src/features/main/domain/repository/beverage_unlock_store.dart';

class BeverageUnlockStoreImpl implements BeverageUnlockStore {
  // legacy(전역) 키: 초기 구현에서 계정 구분이 없어 공유되던 값
  static const _legacyUnlockedPremiumCount =
      'waterlog_unlocked_premium_beverages';
  static const _legacyRewardedProgress = 'waterlog_rewarded_progress';

  static const _maxPremium = 4;

  @override
  Future<BeverageUnlockData> load(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final perUserUnlockedKey = _userKey(uid, 'unlocked_premium_beverages');
    final perUserProgressKey = _userKey(uid, 'rewarded_progress');

    final hasPerUser =
        prefs.containsKey(perUserUnlockedKey) || prefs.containsKey(perUserProgressKey);

    // 마이그레이션: per-user 값이 아직 없고, legacy가 있으면 현재 uid로 1회 이전
    if (!hasPerUser &&
        (prefs.containsKey(_legacyUnlockedPremiumCount) ||
            prefs.containsKey(_legacyRewardedProgress))) {
      final legacyUnlocked =
          (prefs.getInt(_legacyUnlockedPremiumCount) ?? 0).clamp(0, _maxPremium);
      final legacyProgress =
          (prefs.getInt(_legacyRewardedProgress) ?? 0).clamp(0, 1);

      final migrated = BeverageUnlockData(
        unlockedPremiumCount: legacyUnlocked,
        rewardedProgress: legacyProgress,
      );

      await prefs.setInt(perUserUnlockedKey, migrated.unlockedPremiumCount);
      await prefs.setInt(perUserProgressKey, migrated.rewardedProgress);

      // 다른 계정으로 퍼지는 걸 막기 위해 legacy는 제거
      await prefs.remove(_legacyUnlockedPremiumCount);
      await prefs.remove(_legacyRewardedProgress);

      return migrated;
    }

    final unlocked =
        (prefs.getInt(perUserUnlockedKey) ?? 0).clamp(0, _maxPremium);
    final progress = (prefs.getInt(perUserProgressKey) ?? 0).clamp(0, 1);
    return BeverageUnlockData(unlockedPremiumCount: unlocked, rewardedProgress: progress);
  }

  @override
  Future<BeverageUnlockData> onRewardedAdEarned(String uid) async {
    final current = await load(uid);
    if (current.unlockedPremiumCount >= _maxPremium) {
      // 다 해금된 상태면 progress는 0으로 정리
      return _save(uid, current.copyWith(rewardedProgress: 0));
    }

    var nextProgress = current.rewardedProgress + 1;
    var nextUnlocked = current.unlockedPremiumCount;

    if (nextProgress >= 2) {
      nextProgress = 0;
      nextUnlocked = (nextUnlocked + 1).clamp(0, _maxPremium);
    }

    return _save(
      uid,
      current.copyWith(
        unlockedPremiumCount: nextUnlocked,
        rewardedProgress: nextProgress.clamp(0, 1),
      ),
    );
  }

  @override
  Future<BeverageUnlockData> onBadgeEarned(String uid, {int count = 1}) async {
    final current = await load(uid);
    if (count <= 0) return current;

    final nextUnlocked =
        (current.unlockedPremiumCount + count).clamp(0, _maxPremium);

    // 전부 해금되면 광고 progress는 굳이 유지할 필요가 없어서 0으로 정리
    final nextProgress = nextUnlocked >= _maxPremium ? 0 : current.rewardedProgress;

    return _save(
      uid,
      current.copyWith(
        unlockedPremiumCount: nextUnlocked,
        rewardedProgress: nextProgress,
      ),
    );
  }

  String _userKey(String uid, String suffix) => 'waterlog_uid:$uid:$suffix';

  Future<BeverageUnlockData> _save(String uid, BeverageUnlockData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _userKey(uid, 'unlocked_premium_beverages'),
      data.unlockedPremiumCount,
    );
    await prefs.setInt(
      _userKey(uid, 'rewarded_progress'),
      data.rewardedProgress,
    );
    return data;
  }
}

