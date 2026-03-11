import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/core/router/app_router.dart';
import 'src/core/theme/app_theme.dart';

void main() {
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