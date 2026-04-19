import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'app_crashlytics.dart';

/// [NavigatorObserver]로 화면 전환을 Crashlytics [log] / [setCustomKey]에 남김.
class CrashlyticsNavObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _onRouteChanged(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _onRouteChanged(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _onRouteChanged(previousRoute);
    }
  }

  void _onRouteChanged(Route<dynamic> route) {
    final name = route.settings.name ?? route.settings.arguments?.toString() ?? 'unnamed';
    unawaited(_persist(name));
  }

  Future<void> _persist(String routeName) async {
    await AppCrashlytics.setCurrentRoute(routeName);
    await FirebaseCrashlytics.instance.log('nav>$routeName');
  }
}
