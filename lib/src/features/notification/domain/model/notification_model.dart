import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';

// 알림 도메인 모델 (welcome, goal_achieved, reminder 등)
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String message,
    required String createdAt,
    required bool isRead,
    required String type,
  }) = _NotificationModel;
}
