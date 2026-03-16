// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_log_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WaterLogDto _$WaterLogDtoFromJson(Map<String, dynamic> json) {
  return _WaterLogDto.fromJson(json);
}

/// @nodoc
mixin _$WaterLogDto {
  String get date => throw _privateConstructorUsedError;
  int? get cups => throw _privateConstructorUsedError;
  int? get targetCups => throw _privateConstructorUsedError;
  int? get totalMl => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WaterLogDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WaterLogDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaterLogDtoCopyWith<WaterLogDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaterLogDtoCopyWith<$Res> {
  factory $WaterLogDtoCopyWith(
    WaterLogDto value,
    $Res Function(WaterLogDto) then,
  ) = _$WaterLogDtoCopyWithImpl<$Res, WaterLogDto>;
  @useResult
  $Res call({
    String date,
    int? cups,
    int? targetCups,
    int? totalMl,
    String? updatedAt,
  });
}

/// @nodoc
class _$WaterLogDtoCopyWithImpl<$Res, $Val extends WaterLogDto>
    implements $WaterLogDtoCopyWith<$Res> {
  _$WaterLogDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaterLogDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? cups = freezed,
    Object? targetCups = freezed,
    Object? totalMl = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            cups: freezed == cups
                ? _value.cups
                : cups // ignore: cast_nullable_to_non_nullable
                      as int?,
            targetCups: freezed == targetCups
                ? _value.targetCups
                : targetCups // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalMl: freezed == totalMl
                ? _value.totalMl
                : totalMl // ignore: cast_nullable_to_non_nullable
                      as int?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WaterLogDtoImplCopyWith<$Res>
    implements $WaterLogDtoCopyWith<$Res> {
  factory _$$WaterLogDtoImplCopyWith(
    _$WaterLogDtoImpl value,
    $Res Function(_$WaterLogDtoImpl) then,
  ) = __$$WaterLogDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    int? cups,
    int? targetCups,
    int? totalMl,
    String? updatedAt,
  });
}

/// @nodoc
class __$$WaterLogDtoImplCopyWithImpl<$Res>
    extends _$WaterLogDtoCopyWithImpl<$Res, _$WaterLogDtoImpl>
    implements _$$WaterLogDtoImplCopyWith<$Res> {
  __$$WaterLogDtoImplCopyWithImpl(
    _$WaterLogDtoImpl _value,
    $Res Function(_$WaterLogDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaterLogDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? cups = freezed,
    Object? targetCups = freezed,
    Object? totalMl = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$WaterLogDtoImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        cups: freezed == cups
            ? _value.cups
            : cups // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetCups: freezed == targetCups
            ? _value.targetCups
            : targetCups // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalMl: freezed == totalMl
            ? _value.totalMl
            : totalMl // ignore: cast_nullable_to_non_nullable
                  as int?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WaterLogDtoImpl implements _WaterLogDto {
  const _$WaterLogDtoImpl({
    required this.date,
    this.cups,
    this.targetCups = 8,
    this.totalMl,
    this.updatedAt,
  });

  factory _$WaterLogDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WaterLogDtoImplFromJson(json);

  @override
  final String date;
  @override
  final int? cups;
  @override
  @JsonKey()
  final int? targetCups;
  @override
  final int? totalMl;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'WaterLogDto(date: $date, cups: $cups, targetCups: $targetCups, totalMl: $totalMl, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaterLogDtoImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.cups, cups) || other.cups == cups) &&
            (identical(other.targetCups, targetCups) ||
                other.targetCups == targetCups) &&
            (identical(other.totalMl, totalMl) || other.totalMl == totalMl) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, cups, targetCups, totalMl, updatedAt);

  /// Create a copy of WaterLogDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaterLogDtoImplCopyWith<_$WaterLogDtoImpl> get copyWith =>
      __$$WaterLogDtoImplCopyWithImpl<_$WaterLogDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WaterLogDtoImplToJson(this);
  }
}

abstract class _WaterLogDto implements WaterLogDto {
  const factory _WaterLogDto({
    required final String date,
    final int? cups,
    final int? targetCups,
    final int? totalMl,
    final String? updatedAt,
  }) = _$WaterLogDtoImpl;

  factory _WaterLogDto.fromJson(Map<String, dynamic> json) =
      _$WaterLogDtoImpl.fromJson;

  @override
  String get date;
  @override
  int? get cups;
  @override
  int? get targetCups;
  @override
  int? get totalMl;
  @override
  String? get updatedAt;

  /// Create a copy of WaterLogDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaterLogDtoImplCopyWith<_$WaterLogDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
