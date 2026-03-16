import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_log.freezed.dart';

@freezed
class WaterLog with _$WaterLog {
  const factory WaterLog({
    required String date,
    required int cups,
    @Default(8) int targetCups,
    required int totalMl,
    required String updatedAt,
  }) = _WaterLog;
}