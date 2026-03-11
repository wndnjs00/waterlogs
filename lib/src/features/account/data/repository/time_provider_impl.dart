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
  @override
  String nowDateString() {
    final now = DateTime.now();
    return _format(dt: now, withTime: false);
  }

  String _format( {required DateTime dt, required bool withTime}) {
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
}