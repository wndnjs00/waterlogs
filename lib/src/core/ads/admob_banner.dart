import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:waterlogs/src/core/config/app_config.dart';

class AdmobBanner extends StatefulWidget {
  const AdmobBanner({
    super.key,
    this.adSize = AdSize.banner,
    this.backgroundColor = Colors.transparent,
    this.reserveSpaceWhileLoading = true,
  });

  final AdSize adSize;
  final Color backgroundColor;
  final bool reserveSpaceWhileLoading;

  @override
  State<AdmobBanner> createState() => _AdmobBannerState();
}

class _AdmobBannerState extends State<AdmobBanner> {
  BannerAd? _banner;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  void _load() {
    if (kIsWeb) return;

    final adUnitId = _bannerUnitId();
    if (adUnitId == null || adUnitId.trim().isEmpty) return;

    final banner = BannerAd(
      size: widget.adSize,
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _banner = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _banner = null;
            _isLoaded = false;
          });
        },
      ),
    );

    banner.load();
  }

  String? _bannerUnitId() {
    if (kDebugMode) {
      return Platform.isAndroid ? _testBannerAndroid : _testBannerIos;
    }
    // 앱에서 실 유닛 ID를 .env로 주입해두면 그걸 우선 사용
    if (Platform.isAndroid) {
      return AppConfig.admobBannerAndroid ?? _testBannerAndroid;
    }
    if (Platform.isIOS) {
      return AppConfig.admobBannerIos ?? _testBannerIos;
    }
    return null;
  }

  static const _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const _testBannerIos = 'ca-app-pub-3940256099942544/2934735716';

  @override
  Widget build(BuildContext context) {
    final height = widget.adSize.height.toDouble();

    if (!_isLoaded || _banner == null) {
      return widget.reserveSpaceWhileLoading
          ? SizedBox(height: height, width: double.infinity)
          : const SizedBox.shrink();
    }

    final ad = _banner!;
    return Container(
      width: double.infinity,
      height: height,
      color: widget.backgroundColor,
      alignment: Alignment.center,
      child: AdWidget(ad: ad),
    );
  }
}

