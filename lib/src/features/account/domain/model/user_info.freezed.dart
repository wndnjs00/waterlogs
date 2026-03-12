// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return _UserInfo.fromJson(json);
}

/// @nodoc
mixin _$UserInfo {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  LoginProvider get loginProvider => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError; // 회원가입 날짜
  String? get lastDrinkDate =>
      throw _privateConstructorUsedError; // 마지막으로 물마신 날짜
  String? get lastGoalAchieveDate => throw _privateConstructorUsedError;
  int? get streakDays => throw _privateConstructorUsedError;
  int? get dailyGoal => throw _privateConstructorUsedError;
  int? get totalDays => throw _privateConstructorUsedError;
  int? get chatLimit => throw _privateConstructorUsedError;

  /// Serializes this UserInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserInfoCopyWith<UserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoCopyWith<$Res> {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) then) =
      _$UserInfoCopyWithImpl<$Res, UserInfo>;
  @useResult
  $Res call({
    String uid,
    String name,
    String? email,
    LoginProvider loginProvider,
    String? createdAt,
    String? lastDrinkDate,
    String? lastGoalAchieveDate,
    int? streakDays,
    int? dailyGoal,
    int? totalDays,
    int? chatLimit,
  });
}

/// @nodoc
class _$UserInfoCopyWithImpl<$Res, $Val extends UserInfo>
    implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? email = freezed,
    Object? loginProvider = null,
    Object? createdAt = freezed,
    Object? lastDrinkDate = freezed,
    Object? lastGoalAchieveDate = freezed,
    Object? streakDays = freezed,
    Object? dailyGoal = freezed,
    Object? totalDays = freezed,
    Object? chatLimit = freezed,
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
                      as LoginProvider,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastDrinkDate: freezed == lastDrinkDate
                ? _value.lastDrinkDate
                : lastDrinkDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastGoalAchieveDate: freezed == lastGoalAchieveDate
                ? _value.lastGoalAchieveDate
                : lastGoalAchieveDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            streakDays: freezed == streakDays
                ? _value.streakDays
                : streakDays // ignore: cast_nullable_to_non_nullable
                      as int?,
            dailyGoal: freezed == dailyGoal
                ? _value.dailyGoal
                : dailyGoal // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalDays: freezed == totalDays
                ? _value.totalDays
                : totalDays // ignore: cast_nullable_to_non_nullable
                      as int?,
            chatLimit: freezed == chatLimit
                ? _value.chatLimit
                : chatLimit // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserInfoImplCopyWith<$Res>
    implements $UserInfoCopyWith<$Res> {
  factory _$$UserInfoImplCopyWith(
    _$UserInfoImpl value,
    $Res Function(_$UserInfoImpl) then,
  ) = __$$UserInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    String name,
    String? email,
    LoginProvider loginProvider,
    String? createdAt,
    String? lastDrinkDate,
    String? lastGoalAchieveDate,
    int? streakDays,
    int? dailyGoal,
    int? totalDays,
    int? chatLimit,
  });
}

/// @nodoc
class __$$UserInfoImplCopyWithImpl<$Res>
    extends _$UserInfoCopyWithImpl<$Res, _$UserInfoImpl>
    implements _$$UserInfoImplCopyWith<$Res> {
  __$$UserInfoImplCopyWithImpl(
    _$UserInfoImpl _value,
    $Res Function(_$UserInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? email = freezed,
    Object? loginProvider = null,
    Object? createdAt = freezed,
    Object? lastDrinkDate = freezed,
    Object? lastGoalAchieveDate = freezed,
    Object? streakDays = freezed,
    Object? dailyGoal = freezed,
    Object? totalDays = freezed,
    Object? chatLimit = freezed,
  }) {
    return _then(
      _$UserInfoImpl(
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
                  as LoginProvider,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastDrinkDate: freezed == lastDrinkDate
            ? _value.lastDrinkDate
            : lastDrinkDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastGoalAchieveDate: freezed == lastGoalAchieveDate
            ? _value.lastGoalAchieveDate
            : lastGoalAchieveDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        streakDays: freezed == streakDays
            ? _value.streakDays
            : streakDays // ignore: cast_nullable_to_non_nullable
                  as int?,
        dailyGoal: freezed == dailyGoal
            ? _value.dailyGoal
            : dailyGoal // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalDays: freezed == totalDays
            ? _value.totalDays
            : totalDays // ignore: cast_nullable_to_non_nullable
                  as int?,
        chatLimit: freezed == chatLimit
            ? _value.chatLimit
            : chatLimit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserInfoImpl implements _UserInfo {
  const _$UserInfoImpl({
    required this.uid,
    required this.name,
    this.email,
    required this.loginProvider,
    this.createdAt,
    this.lastDrinkDate,
    this.lastGoalAchieveDate,
    this.streakDays,
    this.dailyGoal,
    this.totalDays,
    this.chatLimit,
  });

  factory _$UserInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserInfoImplFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  @override
  final String? email;
  @override
  final LoginProvider loginProvider;
  @override
  final String? createdAt;
  // 회원가입 날짜
  @override
  final String? lastDrinkDate;
  // 마지막으로 물마신 날짜
  @override
  final String? lastGoalAchieveDate;
  @override
  final int? streakDays;
  @override
  final int? dailyGoal;
  @override
  final int? totalDays;
  @override
  final int? chatLimit;

  @override
  String toString() {
    return 'UserInfo(uid: $uid, name: $name, email: $email, loginProvider: $loginProvider, createdAt: $createdAt, lastDrinkDate: $lastDrinkDate, lastGoalAchieveDate: $lastGoalAchieveDate, streakDays: $streakDays, dailyGoal: $dailyGoal, totalDays: $totalDays, chatLimit: $chatLimit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.loginProvider, loginProvider) ||
                other.loginProvider == loginProvider) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastDrinkDate, lastDrinkDate) ||
                other.lastDrinkDate == lastDrinkDate) &&
            (identical(other.lastGoalAchieveDate, lastGoalAchieveDate) ||
                other.lastGoalAchieveDate == lastGoalAchieveDate) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.dailyGoal, dailyGoal) ||
                other.dailyGoal == dailyGoal) &&
            (identical(other.totalDays, totalDays) ||
                other.totalDays == totalDays) &&
            (identical(other.chatLimit, chatLimit) ||
                other.chatLimit == chatLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    name,
    email,
    loginProvider,
    createdAt,
    lastDrinkDate,
    lastGoalAchieveDate,
    streakDays,
    dailyGoal,
    totalDays,
    chatLimit,
  );

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      __$$UserInfoImplCopyWithImpl<_$UserInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserInfoImplToJson(this);
  }
}

abstract class _UserInfo implements UserInfo {
  const factory _UserInfo({
    required final String uid,
    required final String name,
    final String? email,
    required final LoginProvider loginProvider,
    final String? createdAt,
    final String? lastDrinkDate,
    final String? lastGoalAchieveDate,
    final int? streakDays,
    final int? dailyGoal,
    final int? totalDays,
    final int? chatLimit,
  }) = _$UserInfoImpl;

  factory _UserInfo.fromJson(Map<String, dynamic> json) =
      _$UserInfoImpl.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  String? get email;
  @override
  LoginProvider get loginProvider;
  @override
  String? get createdAt; // 회원가입 날짜
  @override
  String? get lastDrinkDate; // 마지막으로 물마신 날짜
  @override
  String? get lastGoalAchieveDate;
  @override
  int? get streakDays;
  @override
  int? get dailyGoal;
  @override
  int? get totalDays;
  @override
  int? get chatLimit;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
