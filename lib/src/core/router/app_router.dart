import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waterlogs/src/core/crashlytics/crashlytics_nav_observer.dart';
import 'package:waterlogs/src/core/router/app_routes.dart';

import '../../features/main/presentation/screen/main_shell_page.dart';
import '../../features/main/presentation/screen/main_screen.dart';
import '../../features/ai/presentation/screen/ai_chat_screen.dart';
import '../../features/badge/presentation/screen/badge_screen.dart';
import '../../features/notification/presentation/screen/notification_screen.dart';
import '../../features/account/presentation/screen/login_screen.dart';
import '../../features/account/presentation/screen/sign_in_screen.dart';
import '../../features/account/presentation/screen/sign_up_screen.dart';
import '../../features/account/presentation/screen/privacy_terms_pdf_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    observers: [CrashlyticsNavObserver()],
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        name: AppRoutes.signInName,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        name: AppRoutes.signUpName,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacyTermsPdf,
        name: AppRoutes.privacyTermsPdfName,
        builder: (context, state) => const PrivacyTermsPdfScreen(),
      ),
      GoRoute(
        path: AppRoutes.notification,
        name: AppRoutes.notificationName,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.badge,
        name: AppRoutes.badgeName,
        builder: (context, state) => const BadgeScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => MainShellPage(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.main,
            name: AppRoutes.mainName,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MainScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.aiHelper,
            name: AppRoutes.aiName,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AiChatScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

