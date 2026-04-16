// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WaterLog {
  String get date => throw _privateConstructorUsedError;

  /// 물 섭취량을 250ml 단위(잔)로 환산한 값. (뱃지/알림/목표는 물만 기준)
  int get cups => throw _privateConstructorUsedError;
  int get targetCups => throw _privateConstructorUsedError;

  /// 모든 음료 합계(ml)
  int get totalMl => throw _privateConstructorUsedError;

  /// 날짜별 음료별 섭취량(ml). key는 BeverageType.id(=enum name)
  Map<String, int> get beverages => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of WaterLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaterLogCopyWith<WaterLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaterLogCopyWith<$Res> {
  factory $WaterLogCopyWith(WaterLog value, $Res Function(WaterLog) then) =
      _$WaterLogCopyWithImpl<$Res, WaterLog>;
  @useResult
  $Res call({
    String date,
    int cups,
    int targetCups,
    int totalMl,
    Map<String, int> beverages,
    String updatedAt,
  });
}

/// @nodoc
class _$WaterLogCopyWithImpl<$Res, $Val extends WaterLog>
    implements $WaterLogCopyWith<$Res> {
  _$WaterLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaterLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? cups = null,
    Object? targetCups = null,
    Object? totalMl = null,
    Object? beverages = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            cups: null == cups
                ? _value.cups
                : cups // ignore: cast_nullable_to_non_nullable
                      as int,
            targetCups: null == targetCups
                ? _value.targetCups
                : targetCups // ignore: cast_nullable_to_non_nullable
                      as int,
            totalMl: null == totalMl
                ? _value.totalMl
                : totalMl // ignore: cast_nullable_to_non_nullable
                      as int,
            beverages: null == beverages
                ? _value.beverages
                : beverages // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WaterLogImplCopyWith<$Res>
    implements $WaterLogCopyWith<$Res> {
  factory _$$WaterLogImplCopyWith(
    _$WaterLogImpl value,
    $Res Function(_$WaterLogImpl) then,
  ) = __$$WaterLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    int cups,
    int targetCups,
    int totalMl,
    Map<String, int> beverages,
    String updatedAt,
  });
}

/// @nodoc
class __$$WaterLogImplCopyWithImpl<$Res>
    extends _$WaterLogCopyWithImpl<$Res, _$WaterLogImpl>
    implements _$$WaterLogImplCopyWith<$Res> {
  __$$WaterLogImplCopyWithImpl(
    _$WaterLogImpl _value,
    $Res Function(_$WaterLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaterLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? cups = null,
    Object? targetCups = null,
    Object? totalMl = null,
    Object? beverages = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$WaterLogImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        cups: null == cups
            ? _value.cups
            : cups // ignore: cast_nullable_to_non_nullable
                  as int,
        targetCups: null == targetCups
            ? _value.targetCups
            : targetCups // ignore: cast_nullable_to_non_nullable
                  as int,
        totalMl: null == totalMl
            ? _value.totalMl
            : totalMl // ignore: cast_nullable_to_non_nullable
                  as int,
        beverages: null == beverages
            ? _value._beverages
            : beverages // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$WaterLogImpl implements _WaterLog {
  const _$WaterLogImpl({
    required this.date,
    required this.cups,
    this.targetCups = 8,
    required this.totalMl,
    final Map<String, int> beverages = const {},
    required this.updatedAt,
  }) : _beverages = beverages;

  @override
  final String date;

  /// 물 섭취량을 250ml 단위(잔)로 환산한 값. (뱃지/알림/목표는 물만 기준)
  @override
  final int cups;
  @override
  @JsonKey()
  final int targetCups;

  /// 모든 음료 합계(ml)
  @override
  final int totalMl;

  /// 날짜별 음료별 섭취량(ml). key는 BeverageType.id(=enum name)
  final Map<String, int> _beverages;

  /// 날짜별 음료별 섭취량(ml). key는 BeverageType.id(=enum name)
  @override
  @JsonKey()
  Map<String, int> get beverages {
    if (_beverages is EqualUnmodifiableMapView) return _beverages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_beverages);
  }

  @override
  final String updatedAt;

  @override
  String toString() {
    return 'WaterLog(date: $date, cups: $cups, targetCups: $targetCups, totalMl: $totalMl, beverages: $beverages, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaterLogImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.cups, cups) || other.cups == cups) &&
            (identical(other.targetCups, targetCups) ||
                other.targetCups == targetCups) &&
            (identical(other.totalMl, totalMl) || other.totalMl == totalMl) &&
            const DeepCollectionEquality().equals(
              other._beverages,
              _beverages,
            ) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    cups,
    targetCups,
    totalMl,
    const DeepCollectionEquality().hash(_beverages),
    updatedAt,
  );

  /// Create a copy of WaterLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaterLogImplCopyWith<_$WaterLogImpl> get copyWith =>
      __$$WaterLogImplCopyWithImpl<_$WaterLogImpl>(this, _$identity);
}

abstract class _WaterLog implements WaterLog {
  const factory _WaterLog({
    required final String date,
    required final int cups,
    final int targetCups,
    required final int totalMl,
    final Map<String, int> beverages,
    required final String updatedAt,
  }) = _$WaterLogImpl;

  @override
  String get date;

  /// 물 섭취량을 250ml 단위(잔)로 환산한 값. (뱃지/알림/목표는 물만 기준)
  @override
  int get cups;
  @override
  int get targetCups;

  /// 모든 음료 합계(ml)
  @override
  int get totalMl;

  /// 날짜별 음료별 섭취량(ml). key는 BeverageType.id(=enum name)
  @override
  Map<String, int> get beverages;
  @override
  String get updatedAt;

  /// Create a copy of WaterLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaterLogImplCopyWith<_$WaterLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
