import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/main/presentation/screen/main_shell_page.dart';
import '../../features/main/presentation/screen/main_screen.dart';
import '../../features/main/presentation/screen/ai_helper_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: MainScreen.routePath,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShellPage(child: child),
        routes: [
          GoRoute(
            path: MainScreen.routePath,
            name: MainScreen.routeName,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MainScreen(),
            ),
          ),
          GoRoute(
            path: AiHelperScreen.routePath,
            name: AiHelperScreen.routeName,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AiHelperScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

