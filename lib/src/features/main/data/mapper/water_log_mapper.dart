import '../../domain/model/water_log.dart';
import '../model/water_log_dto.dart';

class WaterLogMapper {
  static WaterLog toDomain(WaterLogDto dto) {
    return WaterLog(
      date: dto.date ?? '',
      cups: dto.cups ?? 0,
      targetCups: dto.targetCups ?? 8,
      totalMl: dto.totalMl ?? 0,
      updatedAt: dto.updatedAt ?? '',
    );
  }

  static WaterLogDto toDto(WaterLog domain) {
    return WaterLogDto(
      date: domain.date,
      cups: domain.cups,
      targetCups: domain.targetCups,
      totalMl: domain.totalMl,
      updatedAt: domain.updatedAt,
    );
  }
}
