// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_log_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WaterLogDtoImpl _$$WaterLogDtoImplFromJson(Map<String, dynamic> json) =>
    _$WaterLogDtoImpl(
      date: json['date'] as String,
      cups: (json['cups'] as num?)?.toInt(),
      targetCups: (json['targetCups'] as num?)?.toInt() ?? 8,
      totalMl: (json['totalMl'] as num?)?.toInt(),
      beverages: (json['beverages'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$WaterLogDtoImplToJson(_$WaterLogDtoImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'cups': instance.cups,
      'targetCups': instance.targetCups,
      'totalMl': instance.totalMl,
      'beverages': instance.beverages,
      'updatedAt': instance.updatedAt,
    };
