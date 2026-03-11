// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserInfoImpl _$$UserInfoImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      loginProvider: $enumDecode(_$LoginProviderEnumMap, json['loginProvider']),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$UserInfoImplToJson(_$UserInfoImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'loginProvider': _$LoginProviderEnumMap[instance.loginProvider]!,
      'createdAt': instance.createdAt,
    };

const _$LoginProviderEnumMap = {
  LoginProvider.google: 'google',
  LoginProvider.kakao: 'kakao',
  LoginProvider.naver: 'naver',
  LoginProvider.email: 'email',
};
