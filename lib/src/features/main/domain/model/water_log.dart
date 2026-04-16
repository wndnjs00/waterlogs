import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_log.freezed.dart';

@freezed
class WaterLog with _$WaterLog {
  const factory WaterLog({
    required String date,
    /// 물 섭취량을 250ml 단위(잔)로 환산한 값. (뱃지/알림/목표는 물만 기준)
    required int cups,
    @Default(8) int targetCups,
    /// 모든 음료 합계(ml)
    required int totalMl,
    /// 날짜별 음료별 섭취량(ml). key는 BeverageType.id(=enum name)
    @Default({}) Map<String, int> beverages,
    required String updatedAt,
  }) = _WaterLog;
}