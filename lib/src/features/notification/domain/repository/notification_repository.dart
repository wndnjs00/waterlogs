import '../model/notification_model.dart';

abstract class NotificationRepository {
  Stream<List<NotificationModel>> observeNotifications(String uid);
  Future<void> markAsRead(String uid, String notificationId);
}