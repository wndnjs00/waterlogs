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
  }) = _UserInfoDto;

  factory UserInfoDto.fromJson(Map<String, dynamic> json) =>
      _$UserInfoDtoFromJson(json);
}