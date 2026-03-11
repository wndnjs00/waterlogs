// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserInfoDto _$UserInfoDtoFromJson(Map<String, dynamic> json) {
  return _UserInfoDto.fromJson(json);
}

/// @nodoc
mixin _$UserInfoDto {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get loginProvider => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserInfoDtoCopyWith<UserInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoDtoCopyWith<$Res> {
  factory $UserInfoDtoCopyWith(
    UserInfoDto value,
    $Res Function(UserInfoDto) then,
  ) = _$UserInfoDtoCopyWithImpl<$Res, UserInfoDto>;
  @useResult
  $Res call({
    String uid,
    String name,
    String? email,
    String loginProvider,
    String? createdAt,
  });
}

/// @nodoc
class _$UserInfoDtoCopyWithImpl<$Res, $Val extends UserInfoDto>
    implements $UserInfoDtoCopyWith<$Res> {
  _$UserInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? email = freezed,
    Object? loginProvider = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            loginProvider: null == loginProvider
                ? _value.loginProvider
                : loginProvider // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserInfoDtoImplCopyWith<$Res>
    implements $UserInfoDtoCopyWith<$Res> {
  factory _$$UserInfoDtoImplCopyWith(
    _$UserInfoDtoImpl value,
    $Res Function(_$UserInfoDtoImpl) then,
  ) = __$$UserInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    String name,
    String? email,
    String loginProvider,
    String? createdAt,
  });
}

/// @nodoc
class __$$UserInfoDtoImplCopyWithImpl<$Res>
    extends _$UserInfoDtoCopyWithImpl<$Res, _$UserInfoDtoImpl>
    implements _$$UserInfoDtoImplCopyWith<$Res> {
  __$$UserInfoDtoImplCopyWithImpl(
    _$UserInfoDtoImpl _value,
    $Res Function(_$UserInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? email = freezed,
    Object? loginProvider = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$UserInfoDtoImpl(
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        loginProvider: null == loginProvider
            ? _value.loginProvider
            : loginProvider // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserInfoDtoImpl implements _UserInfoDto {
  const _$UserInfoDtoImpl({
    required this.uid,
    required this.name,
    this.email,
    required this.loginProvider,
    this.createdAt,
  });

  factory _$UserInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserInfoDtoImplFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  @override
  final String? email;
  @override
  final String loginProvider;
  @override
  final String? createdAt;

  @override
  String toString() {
    return 'UserInfoDto(uid: $uid, name: $name, email: $email, loginProvider: $loginProvider, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoDtoImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.loginProvider, loginProvider) ||
                other.loginProvider == loginProvider) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uid, name, email, loginProvider, createdAt);

  /// Create a copy of UserInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoDtoImplCopyWith<_$UserInfoDtoImpl> get copyWith =>
      __$$UserInfoDtoImplCopyWithImpl<_$UserInfoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserInfoDtoImplToJson(this);
  }
}

abstract class _UserInfoDto implements UserInfoDto {
  const factory _UserInfoDto({
    required final String uid,
    required final String name,
    final String? email,
    required final String loginProvider,
    final String? createdAt,
  }) = _$UserInfoDtoImpl;

  factory _UserInfoDto.fromJson(Map<String, dynamic> json) =
      _$UserInfoDtoImpl.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  String? get email;
  @override
  String get loginProvider;
  @override
  String? get createdAt;

  /// Create a copy of UserInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInfoDtoImplCopyWith<_$UserInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
