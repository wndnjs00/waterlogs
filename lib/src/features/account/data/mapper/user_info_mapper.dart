import '../../domain/model/user_info.dart';
import '../model/user_info_dto.dart';

class UserInfoMapper {
  // DTO -> Domain
  static UserInfo toDomain(UserInfoDto dto) {
    return UserInfo(
      uid: dto.uid,
      name: dto.name,
      email: dto.email,
      loginProvider: dto.loginProvider.toLoginProvider(),
      createdAt: dto.createdAt,
      lastDrinkDate: dto.lastDrinkDate,
      lastGoalAchieveDate: dto.lastGoalAchieveDate,
      streakDays: dto.streakDays,
      dailyGoal: dto.dailyGoal,
      totalDays: dto.totalDays,
      chatLimit: dto.chatLimit,
    );
  }

  // Domain -> DTO
  static UserInfoDto toDto(UserInfo user) {
    return UserInfoDto(
      uid: user.uid,
      name: user.name,
      email: user.email,
      loginProvider: user.loginProvider.name,
      createdAt: user.createdAt,
      lastDrinkDate: user.lastDrinkDate,
      lastGoalAchieveDate: user.lastGoalAchieveDate,
      streakDays: user.streakDays,
      dailyGoal: user.dailyGoal,
      totalDays: user.totalDays,
      chatLimit: user.chatLimit,
    );
  }
}

extension LoginProviderParser on String {
  LoginProvider toLoginProvider() {
    return LoginProvider.values.firstWhere(
      (e) => e.name == this,
      orElse: () => LoginProvider.email,
    );
  }
}
