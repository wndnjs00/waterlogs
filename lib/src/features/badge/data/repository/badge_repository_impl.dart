import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:waterlogs/src/core/util/firestore_paths.dart';
import 'package:waterlogs/src/features/badge/domain/model/badge.dart';
import 'package:waterlogs/src/features/badge/domain/repository/badge_repository.dart';

class BadgeRepositoryImpl implements BadgeRepository {
  BadgeRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<void> verifyServerCanLoadBadges(String uid) {
    return _firestore
        .collection(FirestorePaths.users)
        .doc(uid)
        .collection(FirestorePaths.badges)
        .limit(1)
        .get(const GetOptions(source: Source.server));
  }

  @override
  Stream<Map<String, Badge>> observeBadges(String uid) {
    return _firestore
        .collection(FirestorePaths.users)
        .doc(uid)
        .collection(FirestorePaths.badges)
        .snapshots()
        .map((snapshot) {
          final map = <String, Badge>{};
          for (final doc in snapshot.docs) {
            final data = doc.data();
            final rawName = (data['name'] as String?)?.trim() ?? '';
            final name = rawName.isNotEmpty ? rawName : (_fallbackName(doc.id) ?? '');
            if (name.isEmpty) continue; // 알 수 없는 문서는 스킵

            final createdAt = data['acquiredDate'] as String? ?? '';
            map[doc.id] = Badge(name: name, createdAt: createdAt);
          }
          return map;
        });
  }

  String? _fallbackName(String badgeId) {
    switch (badgeId) {
      case 'day_2L':
        return '하루 2L 달성';
      case 'week_7days':
        return '7일 연속 달성';
      case 'month_30days':
        return '30일 연속 달성';
      case 'king_6months':
        return '6개월 꾸준함의 왕';
    }
    return null;
  }
}
