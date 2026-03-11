import '../../domain/model/user_info.dart';
import '../model/user_info_dto.dart';


class UserInfoMapper {

  // DTO -> Domain
  static UserInfo toDomain(UserInfoDto dto) {
    return UserInfo(
      uid: dto.uid,
      name: dto.name,
      email: dto.email,
      loginProvider: LoginProvider.values.firstWhere(
            (v) => v.name == dto.loginProvider,
        orElse: () => LoginProvider.email,
      ),
      createdAt: dto.createdAt,
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
    );
  }
}