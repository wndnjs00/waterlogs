import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info_dto.freezed.dart';
part 'user_info_dto.g.dart';

@freezed
class UserInfoDto with _$UserInfoDto {
  const factory UserInfoDto({
    required String uid,
    required String name,
    String? email,
    required String loginProvider,
    String? createdAt,
    String? lastDrinkDate,
    String? lastGoalAchieveDate,
    int? streakDays,
    int? dailyGoal,
    int? totalDays,
    int? chatLimit,
  }) = _UserInfoDto;

  factory UserInfoDto.fromJson(Map<String, dynamic> json) =>
      _$UserInfoDtoFromJson(json);
}