import 'package:waterlogs/src/features/badge/domain/model/badge.dart';

abstract class BadgeRepository {
  Stream<Map<String, Badge>> observeBadges(String uid);

  /// 서버에서 뱃지 컬렉션을 읽을 수 있는지 확인. 오프라인이면 예외. [observeBadges] 스냅샷만 쓰면 오프라인에서 [onError] 없이 빈 캐시만 올 수 있음.
  Future<void> verifyServerCanLoadBadges(String uid);
}
