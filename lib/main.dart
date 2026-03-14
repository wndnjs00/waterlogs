import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:waterlogs/firebase_options.dart';
import 'package:waterlogs/src/core/config/app_config.dart';

import 'src/core/router/app_router.dart';
import 'src/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  KakaoSdk.init(
      nativeAppKey: AppConfig.kakaoNativeAppKey
  );

  NaverLoginSDK.initialize(
    urlScheme: AppConfig.naverUrlScheme,
    clientId: AppConfig.naverClientId,
    clientSecret: AppConfig.naverClientSecret,
    clientName: AppConfig.naverClientName,
  );

  runApp(
    const ProviderScope(
      child: WaterLogsApp(),
    ),
  );
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