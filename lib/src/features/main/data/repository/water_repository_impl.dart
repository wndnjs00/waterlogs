import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:waterlogs/src/features/account/domain/repository/time_provider.dart';
import 'package:waterlogs/src/features/main/domain/constants/badge_type.dart';
import 'package:waterlogs/src/features/main/domain/model/water_log.dart';
import 'package:waterlogs/src/features/main/domain/repository/water_repository.dart';
import 'package:waterlogs/src/features/main/data/datasource/water_remote_datasource.dart';
import 'package:waterlogs/src/features/main/data/mapper/water_log_mapper.dart';
import 'package:waterlogs/src/features/main/data/model/water_log_dto.dart';
import 'package:waterlogs/src/features/main/domain/util/streak_calculator.dart';

class WaterRepositoryImpl implements WaterRepository {
  WaterRepositoryImpl(this._dataSource, this._firestore, this._timeProvider);

  final WaterRemoteDataSource _dataSource;
  final FirebaseFirestore _firestore;
  final TimeProvider _timeProvider;

  static const _users = 'users';
  static const _waterLogs = 'water_logs';
  static const _badges = 'badges';
  static const _notifications = 'notifications';

  @override
  Future<WaterLog?> getTodayLog(String uid, String date) async {
    final dto = await _dataSource.getTodayLog(uid, date);
    return dto != null ? WaterLogMapper.toDomain(dto) : null;
  }

  @override
  Future<void> saveWithAchievement(String uid, WaterLog waterLog) async {
    final userRef = _firestore.collection(_users).doc(uid);
    final logRef = userRef.collection(_waterLogs).doc(waterLog.date);

    await _firestore.runTransaction((transaction) async {
      // Firebase 트랜잭션: 모든 읽기를 쓰기보다 먼저 수행
      final userSnap = await transaction.get(userRef);
      final logSnap = await transaction.get(logRef);

      final data = userSnap.data() as Map<String, dynamic>? ?? {};

      final dailyGoal = (data['dailyGoal'] as num?)?.toInt() ?? 8;
      final currentStreak = (data['streakDays'] as num?)?.toInt() ?? 0;
      final lastGoalDate = data['lastGoalAchievedDate'] as String?;
      final totalDays = (data['totalDays'] as num?)?.toInt() ?? 0;
      final goalAchievedDate = data['goalAchievedDate'] as String?;

      final isFirstRecordToday = !logSnap.exists;
      final yesterday = _timeProvider.yesterdayString();

      final reachedGoalFirstTime = waterLog.cups >= dailyGoal && goalAchievedDate != waterLog.date;

      final newStreak = StreakCalculator.calculate(
        lastGoalDate: lastGoalDate,
        today: waterLog.date,
        yesterday: yesterday,
        currentStreak: currentStreak,
        reachedGoalFirstTime: reachedGoalFirstTime,
      );

      // water_log 저장
      transaction.set(logRef, WaterLogMapper.toDto(waterLog).toJson());

      // user 업데이트
      final updates = <String, dynamic>{
        'streakDays': newStreak,
        'lastDrinkDate': waterLog.date,
      };

      // totalDays는 오늘 처음 기록한 경우에만 증가
      if (isFirstRecordToday) {
        updates['totalDays'] = totalDays + 1;
      }

      // 목표 최초달성시, 날짜기록
      if (reachedGoalFirstTime) {
        updates['goalAchievedDate'] = waterLog.date;
        updates['lastGoalAchievedDate'] = waterLog.date;
      }

      transaction.update(userRef, updates);

      // 목표 달성체크
      if (reachedGoalFirstTime) {
        _createGoalNotification(transaction, userRef);
        _createGoalBadge(transaction, userRef, waterLog.date);
      }

      // streak 기반 배지 처리
      _handleStreakBadges(transaction, userRef, newStreak, waterLog.date);
    });
  }

  // 목표달성 배치
  void _createGoalBadge(
    Transaction transaction,
    DocumentReference userRef,
    String date,
  ) {
    final badgeRef = userRef.collection(_badges).doc(BadgeType.day2L);

    transaction.set(badgeRef, {
      'name': '하루 2L 달성',
      'description': '하루에 8잔 달성!',
      'acquired': true,
      'acquiredDate': date,
    });
  }

  // streak 배지 처리
  void _handleStreakBadges(
    Transaction transaction,
    DocumentReference userRef,
    int newStreak,
    String date,
  ) {
    switch (newStreak) {
      case 7:
        _createBadge(
          transaction,
          userRef,
          BadgeType.week7days,
          '7일 연속 달성',
          '7일 동안 꾸준히 물을 마셨습니다!',
          date,
        );
        break;

      case 30:
        _createBadge(
          transaction,
          userRef,
          BadgeType.month30days,
          '30일 연속 달성',
          '한달 동안 꾸준히 물을 마셨습니다!',
          date,
        );
        break;

      case 180:
        _createBadge(
          transaction,
          userRef,
          BadgeType.king6months,
          '6개월 꾸준함의 왕',
          '6개월 동안 꾸준히 물을 섭취했습니다!',
          date,
        );
        break;
    }
  }

  // 배지가 없을때만 쓰기
  void _createBadge(
    Transaction transaction,
    DocumentReference userRef,
    String badgeId,
    String name,
    String description,
    String date,
  ) {
    final badgeRef = userRef.collection(_badges).doc(badgeId);

    transaction.set(badgeRef, {
      'name': name,
      'description': description,
      'acquired': true,
      'acquiredDate': date,
    });
  }

  void _createGoalNotification(
      Transaction transaction,
      DocumentReference userRef,
      ) {
    final notificationRef = userRef.collection(_notifications).doc();

    transaction.set(notificationRef, {
      'title': '오늘 물섭취 목표 달성 💧',
      'message': '하루 목표 8잔을 모두 마셨어요!',
      'type': 'goal_achieved',
      'createdAt': _timeProvider.nowDateTimeString(),
      'isRead': false,
    });
  }

  @override
  Future<List<WaterLog>> getWeeklyLogs(
    String uid,
    String start,
    String end,
  ) async {
    final list = await _dataSource.getLogsInRange(uid, start, end);
    return list.map(WaterLogMapper.toDomain).toList();
  }

  @override
  Future<List<WaterLog>> getMonthlyLogs(
    String uid,
    String start,
    String end,
  ) async {
    return getWeeklyLogs(uid, start, end);
  }
}
