import 'package:waterlogs/src/features/notification/domain/model/notification_model.dart';

class NotificationState {
  const NotificationState({
    this.notifications = const [],
    this.toastMessage,
  });

  final List<NotificationModel> notifications;
  final String? toastMessage;

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    String? toastMessage,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      toastMessage: toastMessage,
    );
  }

  int get unreadCount =>
      notifications.where((n) => !n.isRead).length;
}
