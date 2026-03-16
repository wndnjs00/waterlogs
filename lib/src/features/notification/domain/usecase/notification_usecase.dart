import '../model/notification_model.dart';
import '../repository/notification_repository.dart';

class NotificationUseCase {
  NotificationUseCase(this._repository);

  final NotificationRepository _repository;

  Stream<List<NotificationModel>> observe(String uid) {
    return _repository.observeNotifications(uid);
  }

  Future<void> markRead(String uid, String id) {
    return _repository.markAsRead(uid, id);
  }
}