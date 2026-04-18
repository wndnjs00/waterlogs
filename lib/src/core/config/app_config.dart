import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {

  static String get kakaoNativeAppKey =>
      dotenv.env['KAKAO_NATIVE_APP_KEY']!;

  static String get naverClientId =>
      dotenv.env['NAVER_CLIENT_ID']!;

  static String get naverClientSecret =>
      dotenv.env['NAVER_CLIENT_SECRET']!;

  static String get naverUrlScheme =>
      dotenv.env['NAVER_URL_SCHEME']!;

  static String get naverClientName =>
      dotenv.env['NAVER_CLIENT_NAME']!;

  static String get googleServerClientId =>
      dotenv.env['GOOGLE_SERVER_CLIENT_ID']!;

  static String? get openAiApiKey {
    final v = dotenv.env['OPENAI_API_KEY']?.trim();
    if (v == null || v.isEmpty) return null;
    return v;
  }

  static String? get admobBannerAndroid {
    final v = dotenv.env['ADMOB_BANNER_ANDROID']?.trim();
    if (v == null || v.isEmpty) return null;
    return v;
  }

  static String? get admobBannerIos {
    final v = dotenv.env['ADMOB_BANNER_IOS']?.trim();
    if (v == null || v.isEmpty) return null;
    return v;
  }

  static String? get admobRewardedAndroid {
    final v = dotenv.env['ADMOB_REWARDED_ANDROID']?.trim();
    if (v == null || v.isEmpty) return null;
    return v;
  }

  static String? get admobRewardedIos {
    final v = dotenv.env['ADMOB_REWARDED_IOS']?.trim();
    if (v == null || v.isEmpty) return null;
    return v;
  }

}
