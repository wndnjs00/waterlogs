import 'package:waterlogs/src/features/badge/domain/model/badge.dart';

abstract class BadgeRepository {
  Stream<Map<String, Badge>> observeBadges(String uid);
}
