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
            final name = data['name'] as String? ?? '';

            if (name.isEmpty) continue;

            final createdAt = data['acquiredDate'] as String? ?? '';
            map[doc.id] = Badge(name: name, createdAt: createdAt);
          }
          return map;
        });
  }
}
