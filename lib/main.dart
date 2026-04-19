import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:waterlogs/firebase_options.dart';
import 'package:waterlogs/src/core/config/app_config.dart';
import 'package:waterlogs/src/core/crashlytics/app_crashlytics.dart';

import 'src/core/notification/local_notification_service.dart';
import 'src/core/router/app_router.dart';
import 'src/core/theme/app_theme.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: ".env");

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await AppCrashlytics.configure();
    await AppCrashlytics.log('app:bootstrap_start');

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      unawaited(FirebaseCrashlytics.instance.recordFlutterFatalError(details));
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      unawaited(
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
      );
      return true;
    };

    // iOS push 권한 요청 + foreground 알림 허용
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    KakaoSdk.init(
      nativeAppKey: AppConfig.kakaoNativeAppKey,
    );

    NaverLoginSDK.initialize(
      urlScheme: AppConfig.naverUrlScheme,
      clientId: AppConfig.naverClientId,
      clientSecret: AppConfig.naverClientSecret,
      clientName: AppConfig.naverClientName,
    );

    // Admob 광고
    unawaited(MobileAds.instance.initialize());

    await LocalNotificationService.initialize();

    // 앱이 포그라운드일 때 수신되는 FCM도 상태바 알림으로 표시
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final title = notification?.title ?? 'WaterLog 알림';
      final body = notification?.body ?? '';

      LocalNotificationService.show(title: title, body: body);
    });

    await AppCrashlytics.log('app:bootstrap_done');

    runApp(
      const ProviderScope(
        child: WaterLogsApp(),
      ),
    );
  }, (Object error, StackTrace stack) {
    unawaited(
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
    );
  });
}

class WaterLogsApp extends ConsumerWidget {
  const WaterLogsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'WaterLog',
      theme: buildAppTheme(),
      routerConfig: router,
    );
  }
}