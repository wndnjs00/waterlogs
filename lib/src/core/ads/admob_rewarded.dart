import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:waterlogs/src/core/config/app_config.dart';

class AdmobRewarded {
  AdmobRewarded._();

  static const _testRewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const _testRewardedIos = 'ca-app-pub-3940256099942544/1712485313';

  static String? _rewardedUnitId() {
    final fromEnv = Platform.isAndroid
        ? AppConfig.admobRewardedAndroid
        : (Platform.isIOS ? AppConfig.admobRewardedIos : null);
    if (fromEnv != null && fromEnv.trim().isNotEmpty) return fromEnv;

    if (Platform.isAndroid) return _testRewardedAndroid;
    if (Platform.isIOS) return _testRewardedIos;
    return null;
  }

  /// 보상형 광고를 1회 보여주고, 보상 획득 여부를 반환
  static Future<bool> showOnce() async {
    if (kIsWeb) return false;

    final unitId = _rewardedUnitId();
    if (unitId == null) return false;

    final completer = Completer<bool>();
    RewardedAd? ad;
    var earned = false;

    await RewardedAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (loaded) {
          ad = loaded;

          loaded.fullScreenContentCallback = FullScreenContentCallback(
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete(false);
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete(earned);
            },
          );

          loaded.show(
            onUserEarnedReward: (_, __) {
              earned = true;
            },
          );
        },
        onAdFailedToLoad: (error) {
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );

    final result = await completer.future;
    ad?.dispose();
    return result;
  }
}

