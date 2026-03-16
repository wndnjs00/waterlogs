/// 알림 도메인 모델 (welcome, goal_achieved, reminder 등)
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
    required this.type,
  });

  final String id;
  final String title;
  final String message;
  final String createdAt;
  final bool isRead;
  final String type;

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? createdAt,
    bool? isRead,
    String? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}
