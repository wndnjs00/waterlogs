import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/asset_path.dart';
import '../../../account/domain/model/user_info.dart';
import '../../../account/presentation/viewmodel/auth_provider.dart';
import '../../../account/presentation/viewmodel/state/auth_view_state.dart';
import '../../../notification/presentation/di/notification_providers.dart';
import '../widgets/dialog/signout_dialog.dart';

int _mainShellSelectedIndex(BuildContext context) {
  final path = GoRouterState.of(context).uri.path;
  if (path.startsWith(AppRoutes.aiHelper)) {
    return 1;
  }
  return 0;
}

void _onMainShellTabTapped(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.go(AppRoutes.main);
      break;
    case 1:
      context.go(AppRoutes.aiHelper);
      break;
  }
}

class MainShellPage extends ConsumerWidget {
  const MainShellPage({super.key, required this.child});

  final Widget child;

  static Future<void> _onLogoutTap(
    BuildContext context,
    WidgetRef ref,
    LoginProvider? loginProvider,
  ) async {
    await ref.read(authViewModelProvider.notifier).logout(loginProvider);
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final loginProvider = authState.user?.loginProvider;
    final notificationState = ref.watch(notificationViewModelProvider);
    final unreadCount = notificationState.unreadCount;

    ref.listen<AuthViewState>(authViewModelProvider, (previous, next) {
      final msg = next.toastMessage;
      if (msg != null && msg.isNotEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        ref.read(authViewModelProvider.notifier).clearToast();
      }
    });

    ref.listen<AuthViewState>(authViewModelProvider, (previous, next) {
      if (previous?.user != null && next.user == null && context.mounted) {
        context.go(AppRoutes.login);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        title: const Text('WaterLog'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            // tooltip/Semantics → Android content-desc (Appium ACCESSIBILITY_ID)
            child: Semantics(
              label: '뱃지',
              button: true,
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.badge),
                child: const Image(
                  image: AssetImage(AssetPath.badgeIcon),
                  width: 24,
                  height: 24,
                  excludeFromSemantics: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Badge(
              isLabelVisible: unreadCount > 0,
              alignment: AlignmentDirectional.topEnd,
              offset: const Offset(-7, 9),
              label: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
              backgroundColor: Colors.red,
              child: IconButton(
                tooltip: '알림',
                icon: const Icon(Icons.notifications, size: 28),
                onPressed: () => context.push(AppRoutes.notification),
              ),
            ),
          ),
          // tooltip → Android content-desc (Appium ACCESSIBILITY_ID)
          IconButton(
            tooltip: '로그아웃',
            onPressed: () => _onLogoutTap(context, ref, loginProvider),
            icon: const Image(
              image: AssetImage(AssetPath.logoutIcon),
              width: 24,
              height: 24,
              excludeFromSemantics: true,
            ),
          ),
          IconButton(
            tooltip: '회원탈퇴',
            onPressed: () => signOutDialog(
              context: context,
              ref: ref,
              loginProvider: loginProvider,
            ),
            icon: const Image(
              image: AssetImage(AssetPath.signoutIcon),
              width: 20,
              height: 20,
              excludeFromSemantics: true,
            ),
          ),
        ],
      ),
      body: child,
      // 탭들 임시 비활성화
      bottomNavigationBar: null,
      // bottomNavigationBar: NavigationBar(
      //   selectedIndex: _mainShellSelectedIndex(context),
      //   onDestinationSelected: (index) => _onMainShellTabTapped(context, index),
      //   destinations: const [
      //     NavigationDestination(
      //       icon: Icon(Icons.water_drop_outlined),
      //       label: '물마시기',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.chat_bubble_outline),
      //       label: 'Ai 도우미',
      //     ),
      //   ],
      // ),
    );
  }
}
