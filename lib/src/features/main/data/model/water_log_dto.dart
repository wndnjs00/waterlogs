import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_log_dto.freezed.dart';
part 'water_log_dto.g.dart';

@freezed
class WaterLogDto with _$WaterLogDto {
  const factory WaterLogDto({
    required String date,
    int? cups,
    @Default(8) int? targetCups,
    int? totalMl,
    Map<String, int>? beverages,
    String? updatedAt,
  }) = _WaterLogDto;

  factory WaterLogDto.fromJson(Map<String, dynamic> json) =>
      _$WaterLogDtoFromJson(json);
}
