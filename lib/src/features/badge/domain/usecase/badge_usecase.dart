import 'package:waterlogs/src/features/badge/domain/model/badge.dart';
import 'package:waterlogs/src/features/badge/domain/repository/badge_repository.dart';

class BadgeUseCase {
  final BadgeRepository _repository;

  BadgeUseCase(this._repository);

  Stream<Map<String, Badge>> observe(String uid) => _repository.observeBadges(uid);
}
