import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    required String uid,
    required String name,
    String? email,
    required LoginProvider loginProvider,
    String? createdAt, // 회원가입 날짜
    String? lastDrinkDate, // 마지막으로 물마신 날짜
    String? lastGoalAchieveDate,
    int? streakDays, //연속 섭취 일수
    int? dailyGoal,
    int? totalDays, //총 기록한 일수
    int? chatLimit,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}

enum LoginProvider {
  google,
  kakao,
  naver,
  email,
}