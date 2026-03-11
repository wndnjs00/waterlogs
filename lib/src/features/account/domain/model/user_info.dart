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