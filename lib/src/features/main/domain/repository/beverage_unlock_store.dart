import 'package:waterlogs/src/features/main/domain/model/beverage_unlock_data.dart';

abstract class BeverageUnlockStore {
  Future<BeverageUnlockData> load(String uid);

  /// 보상형 광고를 1회 시청(보상 획득) 처리.
  /// 2회 누적되면 음료 1개를 해금하고 progress를 0으로 리셋.
  Future<BeverageUnlockData> onRewardedAdEarned(String uid);

  /// 뱃지 1개 획득당 음료 1개 해금.
  Future<BeverageUnlockData> onBadgeEarned(String uid, {int count = 1});
}

