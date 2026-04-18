class BeverageUnlockData {
  /// 커피/주스/탄산/우유 중 해금된 개수 (0~4)
  final int unlockedPremiumCount;

  /// 다음 해금까지 누적된 보상형 광고 시청 횟수 (0~1)
  final int rewardedProgress;

  const BeverageUnlockData({
    required this.unlockedPremiumCount,
    required this.rewardedProgress,
  });

  BeverageUnlockData copyWith({
    int? unlockedPremiumCount,
    int? rewardedProgress,
  }) {
    return BeverageUnlockData(
      unlockedPremiumCount: unlockedPremiumCount ?? this.unlockedPremiumCount,
      rewardedProgress: rewardedProgress ?? this.rewardedProgress,
    );
  }
}

