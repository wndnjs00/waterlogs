import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:waterlogs/src/core/util/firestore_paths.dart';
import 'package:waterlogs/src/features/main/domain/constants/badge_type.dart';
import '../model/save_with_achievement_result.dart';
import '../model/water_log_dto.dart';

typedef SaveWithAchievementCompute =
    SaveWithAchievementResult Function(
      Map<String, dynamic>? userData,
      bool logExists,
      String yesterday,
    );

class WaterRemoteDataSource {
  WaterRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<WaterLogDto?> getTodayLog(String uid, String date) async {
    final snapshot = await _firestore
        .collection(FirestorePaths.users)
        .doc(uid)
        .collection(FirestorePaths.waterLogs)
        .doc(date)
        .get();

    if (!snapshot.exists || snapshot.data() == null) return null;
    return WaterLogDto.fromJson({'date': snapshot.id, ...?snapshot.data()});
  }

  // 트랜잭션으로 물 기록 저장 + 유저/배지/알림 갱신, 계산 로직은 compute에 위임.
  Future<void> saveWithAchievement({
    required String uid,
    required WaterLogDto dto,
    required String yesterday,
    required String nowDateTimeString,
    required SaveWithAchievementCompute compute,
  }) async {
    final userRef = _firestore.collection(FirestorePaths.users).doc(uid);
    final logRef = userRef.collection(FirestorePaths.waterLogs).doc(dto.date);

    await _firestore.runTransaction((transaction) async {
      final userSnap = await transaction.get(userRef);
      final logSnap = await transaction.get(logRef);

      final userData = userSnap.data();
      final logExists = logSnap.exists;

      final result = compute(userData, logExists, yesterday);

      transaction.set(logRef, dto.toJson());
      transaction.update(userRef, result.userUpdate);

      if (result.createGoalNotification) {
        _createGoalNotification(transaction, userRef, nowDateTimeString);
      }
      if (result.createGoalBadge) {
        _createGoalBadge(transaction, userRef, dto.date);
      }
      if (result.streakBadgeDocId != null) {
        _createStreakBadge(
          transaction,
          userRef,
          result.streakBadgeDocId!,
          dto.date,
        );
      }
    });
  }

  void _createGoalBadge(
    Transaction transaction,
    DocumentReference userRef,
    String date,
  ) {
    final badgeRef = userRef
        .collection(FirestorePaths.badges)
        .doc(BadgeType.day2L);

    transaction.set(badgeRef, {
      'name': '하루 2L 달성',
      'description': '하루에 8잔 달성!',
      'acquired': true,
      'acquiredDate': date,
    });
  }

  void _createStreakBadge(
    Transaction transaction,
    DocumentReference userRef,
    String badgeDocId,
    String date,
  ) {
    final badgeRef = userRef.collection(FirestorePaths.badges).doc(badgeDocId);
    final content = _streakBadgeContent(badgeDocId, date);
    transaction.set(badgeRef, content);
  }

  Map<String, dynamic> _streakBadgeContent(String badgeDocId, String date) {
    switch (badgeDocId) {
      case BadgeType.week7days:
        return {
          'name': '7일 연속 달성',
          'description': '7일 동안 꾸준히 물을 마셨습니다!',
          'acquired': true,
          'acquiredDate': date,
        };

      case BadgeType.month30days:
        return {
          'name': '30일 연속 달성',
          'description': '한달 동안 꾸준히 물을 마셨습니다!',
          'acquired': true,
          'acquiredDate': date,
        };

      case BadgeType.king6months:
        return {
          'name': '6개월 꾸준함의 왕',
          'description': '6개월 동안 꾸준히 물을 섭취했습니다!',
          'acquired': true,
          'acquiredDate': date,
        };

      default:
        throw Exception('Unknown badge type: $badgeDocId');
    }
  }

  void _createGoalNotification(
    Transaction transaction,
    DocumentReference userRef,
    String nowDateTimeString,
  ) {
    final notificationRef = userRef
        .collection(FirestorePaths.notifications)
        .doc();

    transaction.set(notificationRef, {
      'title': '오늘 물섭취 목표 달성 💧',
      'message': '하루 목표 8잔을 모두 마셨어요!',
      'type': 'goal_achieved',
      'createdAt': nowDateTimeString,
      'isRead': false,
    });
  }

  Future<List<WaterLogDto>> getLogsInRange(
    String uid,
    String start,
    String end,
  ) async {
    final snapshot = await _firestore
        .collection(FirestorePaths.users)
        .doc(uid)
        .collection(FirestorePaths.waterLogs)
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: start)
        .where(FieldPath.documentId, isLessThanOrEqualTo: end)
        .get();

    return snapshot.docs.map((doc) {
      return WaterLogDto.fromJson({'date': doc.id, ...?doc.data()});
    }).toList();
  }
}
