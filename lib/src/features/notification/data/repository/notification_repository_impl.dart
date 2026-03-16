import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:waterlogs/src/core/util/firestore_paths.dart';
import 'package:waterlogs/src/features/notification/domain/model/notification_model.dart';
import 'package:waterlogs/src/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<List<NotificationModel>> observeNotifications(String uid) {
    return _firestore
        .collection(FirestorePaths.users)
        .doc(uid)
        .collection(FirestorePaths.notifications)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return NotificationModel(
          id: doc.id,
          title: data['title'] as String? ?? '',
          message: data['message'] as String? ?? '',
          createdAt: data['createdAt'] as String? ?? '',
          isRead: data['isRead'] as bool? ?? false,
          type: data['type'] as String? ?? '',
        );
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  @override
  Future<void> markAsRead(String uid, String notificationId) {
    return _firestore
        .collection(FirestorePaths.users)
        .doc(uid)
        .collection(FirestorePaths.notifications)
        .doc(notificationId)
        .update({'isRead': true});
  }
}
