import '../../domain/repository/time_provider.dart';

class TimeProviderImpl implements TimeProvider {
  const TimeProviderImpl();

  // 예: "yyyy/MM/dd HH:mm:ss"
  @override
  String nowDateTimeString() {
    final now = DateTime.now();
    return _format(dt: now, withTime: true);
  }

  // 예: "yyyy/MM/dd"
  // TODO: 이 코드는 안쓰임 (삭제?)
  @override
  String nowDateString() {
    final now = DateTime.now();
    return _format(dt: now, withTime: false);
  }

  // 마지막 기록날짜 (streak(연속 기록))이 어제인지 확인
  // 어제 날짜 (yyyy-MM-dd). streak 계산용
  @override
  String yesterdayString() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _isoDate(yesterday);
  }

  // 주간조회 시작일
  // 해당 주 월요일 (yyyy-MM-dd)
  @override
  String weekStart() {
    final now = DateTime.now();
    final weekday = now.weekday;
    final monday = now.subtract(Duration(days: weekday - 1));
    return _isoDate(monday);
  }

  // 월간조회 시작일
  // 해당 월 1일 (yyyy-MM-dd)
  @override
  String monthStart() {
    final now = DateTime.now();
    final first = DateTime(now.year, now.month, 1);
    return _isoDate(first);
  }

  // 물 로그용 날짜 키 (Firestore 문서 ID 호환, yyyy-MM-dd)
  @override
  String waterLogDateString() {
    return _isoDate(DateTime.now());
  }

  // 알림 목록 표시용 시간 (HH:mm)
  @override
  String formatNotificationTime(String dateTime) {
    try {
      // ISO 형식 (yyyy-MM-dd'T'HH:mm:ss'Z')
      if (dateTime.contains('T')) {
        final dt = DateTime.parse(dateTime);
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
      // Flutter 저장 형식 (yyyy/MM/dd HH:mm:ss)
      final parts = dateTime.split(' ');
      if (parts.length >= 2) {
        final timePart = parts[1];
        final timeComponents = timePart.split(':');
        if (timeComponents.length >= 2) {
          return '${timeComponents[0].padLeft(2, '0')}:${timeComponents[1].padLeft(2, '0')}';
        }
      }
    } catch (_) {}
    return '--:--';
  }

  String _format({required DateTime dt, required bool withTime}) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final date = '$y/$m/$d';

    if (!withTime) return date;

    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final ss = dt.second.toString().padLeft(2, '0');
    return '$date $hh:$mm:$ss';
  }

  static String _isoDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}