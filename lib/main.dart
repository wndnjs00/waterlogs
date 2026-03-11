import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waterlogs/firebase_options.dart';

import 'src/core/router/app_router.dart';
import 'src/core/theme/app_theme.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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