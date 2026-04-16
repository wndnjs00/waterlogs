import '../../domain/model/water_log.dart';
import '../model/water_log_dto.dart';

class WaterLogMapper {
  static WaterLog toDomain(WaterLogDto dto) {
    final beverages = dto.beverages ?? const <String, int>{};
    final totalMl = dto.totalMl ?? beverages.values.fold<int>(0, (s, v) => s + v);
    final cups = dto.cups ?? ((beverages['water'] ?? 0) ~/ 250);

    return WaterLog(
      date: dto.date,
      cups: cups,
      targetCups: dto.targetCups ?? 8,
      totalMl: totalMl,
      beverages: beverages,
      updatedAt: dto.updatedAt ?? '',
    );
  }

  static WaterLogDto toDto(WaterLog domain) {
    return WaterLogDto(
      date: domain.date,
      cups: domain.cups,
      targetCups: domain.targetCups,
      totalMl: domain.totalMl,
      beverages: domain.beverages.isEmpty ? null : domain.beverages,
      updatedAt: domain.updatedAt,
    );
  }
}
