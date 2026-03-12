// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserInfoDtoImpl _$$UserInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoDtoImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      loginProvider: json['loginProvider'] as String,
      createdAt: json['createdAt'] as String?,
      lastDrinkDate: json['lastDrinkDate'] as String?,
      lastGoalAchieveDate: json['lastGoalAchieveDate'] as String?,
      streakDays: (json['streakDays'] as num?)?.toInt(),
      dailyGoal: (json['dailyGoal'] as num?)?.toInt(),
      totalDays: (json['totalDays'] as num?)?.toInt(),
      chatLimit: (json['chatLimit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UserInfoDtoImplToJson(_$UserInfoDtoImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'loginProvider': instance.loginProvider,
      'createdAt': instance.createdAt,
      'lastDrinkDate': instance.lastDrinkDate,
      'lastGoalAchieveDate': instance.lastGoalAchieveDate,
      'streakDays': instance.streakDays,
      'dailyGoal': instance.dailyGoal,
      'totalDays': instance.totalDays,
      'chatLimit': instance.chatLimit,
    };
