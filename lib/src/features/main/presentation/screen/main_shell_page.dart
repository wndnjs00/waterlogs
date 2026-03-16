import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'main_screen.dart';
/*import 'ai_helper_screen.dart';*/
import '../../../../core/router/app_routes.dart';
import '../../../../core/util/asset_path.dart';
import '../../../account/domain/model/user_info.dart';
import '../../../account/presentation/viewmodel/auth_provider.dart';
import '../../../account/presentation/viewmodel/state/auth_view_state.dart';
import '../../../notification/presentation/di/notification_providers.dart';
import '../widgets/dialog/badge_info_dialog.dart';
import '../widgets/dialog/signout_dialog.dart';

class MainShellPage extends ConsumerWidget {
  const MainShellPage({super.key, required this.child});

  final Widget child;

  /* bottomNavigationBar 추가시, 주석 해제 */
  // int _calculateSelectedIndex(BuildContext context) {
  //   final location = GoRouterState.of(context).uri.toString();
  //   if (location.startsWith(AiHelperScreen.routePath)) {
  //     return 1;
  //   }
  //   return 0;
  // }
  //
  // void _onItemTapped(BuildContext context, int index) {
  //   switch (index) {
  //     case 0:
  //       context.go(MainScreen.routePath);
  //       break;
  //     case 1:
  //       context.go(AiHelperScreen.routePath);
  //       break;
  //   }
  // }


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
      appBar: AppBar(
        title: const Text('WaterLog'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GestureDetector(
              onTap: () => showBadgeInfoDialog(context),
              child: const Image(
                image: AssetImage(AssetPath.badgeIcon),
                width: 24,
                height: 24,
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
                icon: const Icon(Icons.notifications, size: 28),
                onPressed: () => context.push(AppRoutes.notification),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GestureDetector(
              onTap: () => _onLogoutTap(context, ref, loginProvider),
              child: const Image(
                image: AssetImage(AssetPath.logoutIcon),
                width: 24,
                height: 24,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GestureDetector(
              onTap: () => signOutDialog(
                context: context,
                ref: ref,
                loginProvider: loginProvider,
              ),
              child: const Image(
                image: AssetImage(AssetPath.signoutIcon),
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],
      ),
      body: child,

      /* bottomNavigationBar 추가시, 주석 해제 */
      // bottomNavigationBar: NavigationBar(
      //   selectedIndex: _calculateSelectedIndex(context),
      //   onDestinationSelected: (index) => _onItemTapped(context, index),
      //   destinations: const [
      //     NavigationDestination(
      //       icon: Icon(Icons.home),
      //       label: '물마시기',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.star),
      //       label: 'Ai도우미',
      //     ),
      //   ],
      // ),
    );
  }
}
