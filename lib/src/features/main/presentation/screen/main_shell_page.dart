import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main_screen.dart';
/*import 'ai_helper_screen.dart';*/

class MainShellPage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WaterLog'),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.check_circle),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.notifications),
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