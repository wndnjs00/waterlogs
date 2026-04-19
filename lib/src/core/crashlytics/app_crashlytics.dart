import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../features/account/domain/model/user_info.dart';

/// Crashlytics 래퍼
///
/// - 사용자 구분: [FirebaseCrashlytics.setUserIdentifier]
/// - 앱/유저 상태: [FirebaseCrashlytics.setCustomKey]
/// - 세션 타임라인: [FirebaseCrashlytics.log]
class AppCrashlytics {
  AppCrashlytics._();

  static FirebaseCrashlytics get _c => FirebaseCrashlytics.instance;

  /// [Firebase.initializeApp] 직후 한 번 호출
  static Future<void> configure() async {
    await _c.setCrashlyticsCollectionEnabled(!kDebugMode);
    await _c.setCustomKey(
      'build_mode',
      kDebugMode ? 'debug' : (kProfileMode ? 'profile' : 'release'),
    );
    if (!kDebugMode) {
      final crashed = await _c.didCrashOnPreviousExecution();
      if (crashed) {
        await _c.log('cold_start_after_previous_crash');
      }
    }
  }

  /// 로그인 세션과 Firestore 프로필이 바뀔 때마다 호출 (로그아웃 시 `null`)
  static Future<void> syncUserContext(UserInfo? user) async {
    if (user == null) {
      await _c.setUserIdentifier('');
      await _c.setCustomKey('logged_in', false);
      await _c.log('auth:user_cleared');
      return;
    }

    await _c.setUserIdentifier(user.uid);
    await _c.setCustomKey('logged_in', true);
    await _c.setCustomKey('login_provider', user.loginProvider.name);
    await _c.setCustomKey(
      'has_email',
      user.email != null && user.email!.trim().isNotEmpty,
    );

    final goal = user.dailyGoal;
    await _c.setCustomKey('daily_goal', goal ?? -1);

    final streak = user.streakDays;
    await _c.setCustomKey('streak_days', streak ?? -1);

    final totalDays = user.totalDays;
    await _c.setCustomKey('total_record_days', totalDays ?? -1);

    final chatLimit = user.chatLimit;
    await _c.setCustomKey('chat_limit', chatLimit ?? -1);

    await _c.log('auth:user_context_sync');
  }

  /// 현재 화면(라우트 이름) — 크래시 시점 스냅샷용
  static Future<void> setCurrentRoute(String routeName) async {
    await _c.setCustomKey('current_route', routeName);
  }

  static Future<void> setCustomKey(String key, Object value) =>
      _c.setCustomKey(key, value);

  static Future<void> log(String message) => _c.log(message);

  /// 물 기록 화면의 최근 상태(크래시 시점 디버깅용)
  static Future<void> syncWaterSession({
    String? logDate,
    int? cups,
    bool? hasUnsavedDraft,
  }) async {
    if (logDate != null) await _c.setCustomKey('water_log_date', logDate);
    if (cups != null) await _c.setCustomKey('water_today_cups', cups);
    if (hasUnsavedDraft != null) {
      await _c.setCustomKey('water_has_unsaved', hasUnsavedDraft);
    }
  }

  /// 잡아낸 예외를 비치명(non-fatal) 리포트로 남김
  static Future<void> recordHandledError(
    Object exception,
    StackTrace stackTrace, {
    String? reason,
  }) {
    return _c.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: false,
    );
  }
}
