// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WaterViewState {
  WaterLog? get todayLog => throw _privateConstructorUsedError;
  bool get isUpdating => throw _privateConstructorUsedError;

  /// Firestore에 반영되지 않은 로컬 변경이 있음 (+/- 후 저장 전)
  bool get hasUnsavedChanges => throw _privateConstructorUsedError;
  List<WaterLog> get weeklyLogs => throw _privateConstructorUsedError;
  List<WaterLog> get monthlyLogs => throw _privateConstructorUsedError;
  BeverageType get selectedBeverage => throw _privateConstructorUsedError;

  /// 현재 선택된 음료의 "한 잔" 용량(ml). 가운데 박스는 이 값을 고정 표시.
  int get servingMl => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of WaterViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WaterViewStateCopyWith<WaterViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaterViewStateCopyWith<$Res> {
  factory $WaterViewStateCopyWith(
    WaterViewState value,
    $Res Function(WaterViewState) then,
  ) = _$WaterViewStateCopyWithImpl<$Res, WaterViewState>;
  @useResult
  $Res call({
    WaterLog? todayLog,
    bool isUpdating,
    bool hasUnsavedChanges,
    List<WaterLog> weeklyLogs,
    List<WaterLog> monthlyLogs,
    BeverageType selectedBeverage,
    int servingMl,
    String? errorMessage,
  });

  $WaterLogCopyWith<$Res>? get todayLog;
}

/// @nodoc
class _$WaterViewStateCopyWithImpl<$Res, $Val extends WaterViewState>
    implements $WaterViewStateCopyWith<$Res> {
  _$WaterViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WaterViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todayLog = freezed,
    Object? isUpdating = null,
    Object? hasUnsavedChanges = null,
    Object? weeklyLogs = null,
    Object? monthlyLogs = null,
    Object? selectedBeverage = null,
    Object? servingMl = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            todayLog: freezed == todayLog
                ? _value.todayLog
                : todayLog // ignore: cast_nullable_to_non_nullable
                      as WaterLog?,
            isUpdating: null == isUpdating
                ? _value.isUpdating
                : isUpdating // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasUnsavedChanges: null == hasUnsavedChanges
                ? _value.hasUnsavedChanges
                : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
                      as bool,
            weeklyLogs: null == weeklyLogs
                ? _value.weeklyLogs
                : weeklyLogs // ignore: cast_nullable_to_non_nullable
                      as List<WaterLog>,
            monthlyLogs: null == monthlyLogs
                ? _value.monthlyLogs
                : monthlyLogs // ignore: cast_nullable_to_non_nullable
                      as List<WaterLog>,
            selectedBeverage: null == selectedBeverage
                ? _value.selectedBeverage
                : selectedBeverage // ignore: cast_nullable_to_non_nullable
                      as BeverageType,
            servingMl: null == servingMl
                ? _value.servingMl
                : servingMl // ignore: cast_nullable_to_non_nullable
                      as int,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of WaterViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WaterLogCopyWith<$Res>? get todayLog {
    if (_value.todayLog == null) {
      return null;
    }

    return $WaterLogCopyWith<$Res>(_value.todayLog!, (value) {
      return _then(_value.copyWith(todayLog: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WaterViewStateImplCopyWith<$Res>
    implements $WaterViewStateCopyWith<$Res> {
  factory _$$WaterViewStateImplCopyWith(
    _$WaterViewStateImpl value,
    $Res Function(_$WaterViewStateImpl) then,
  ) = __$$WaterViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    WaterLog? todayLog,
    bool isUpdating,
    bool hasUnsavedChanges,
    List<WaterLog> weeklyLogs,
    List<WaterLog> monthlyLogs,
    BeverageType selectedBeverage,
    int servingMl,
    String? errorMessage,
  });

  @override
  $WaterLogCopyWith<$Res>? get todayLog;
}

/// @nodoc
class __$$WaterViewStateImplCopyWithImpl<$Res>
    extends _$WaterViewStateCopyWithImpl<$Res, _$WaterViewStateImpl>
    implements _$$WaterViewStateImplCopyWith<$Res> {
  __$$WaterViewStateImplCopyWithImpl(
    _$WaterViewStateImpl _value,
    $Res Function(_$WaterViewStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WaterViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todayLog = freezed,
    Object? isUpdating = null,
    Object? hasUnsavedChanges = null,
    Object? weeklyLogs = null,
    Object? monthlyLogs = null,
    Object? selectedBeverage = null,
    Object? servingMl = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$WaterViewStateImpl(
        todayLog: freezed == todayLog
            ? _value.todayLog
            : todayLog // ignore: cast_nullable_to_non_nullable
                  as WaterLog?,
        isUpdating: null == isUpdating
            ? _value.isUpdating
            : isUpdating // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasUnsavedChanges: null == hasUnsavedChanges
            ? _value.hasUnsavedChanges
            : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
                  as bool,
        weeklyLogs: null == weeklyLogs
            ? _value._weeklyLogs
            : weeklyLogs // ignore: cast_nullable_to_non_nullable
                  as List<WaterLog>,
        monthlyLogs: null == monthlyLogs
            ? _value._monthlyLogs
            : monthlyLogs // ignore: cast_nullable_to_non_nullable
                  as List<WaterLog>,
        selectedBeverage: null == selectedBeverage
            ? _value.selectedBeverage
            : selectedBeverage // ignore: cast_nullable_to_non_nullable
                  as BeverageType,
        servingMl: null == servingMl
            ? _value.servingMl
            : servingMl // ignore: cast_nullable_to_non_nullable
                  as int,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$WaterViewStateImpl extends _WaterViewState {
  const _$WaterViewStateImpl({
    this.todayLog,
    this.isUpdating = false,
    this.hasUnsavedChanges = false,
    final List<WaterLog> weeklyLogs = const [],
    final List<WaterLog> monthlyLogs = const [],
    this.selectedBeverage = BeverageType.water,
    this.servingMl = 250,
    this.errorMessage,
  }) : _weeklyLogs = weeklyLogs,
       _monthlyLogs = monthlyLogs,
       super._();

  @override
  final WaterLog? todayLog;
  @override
  @JsonKey()
  final bool isUpdating;

  /// Firestore에 반영되지 않은 로컬 변경이 있음 (+/- 후 저장 전)
  @override
  @JsonKey()
  final bool hasUnsavedChanges;
  final List<WaterLog> _weeklyLogs;
  @override
  @JsonKey()
  List<WaterLog> get weeklyLogs {
    if (_weeklyLogs is EqualUnmodifiableListView) return _weeklyLogs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyLogs);
  }

  final List<WaterLog> _monthlyLogs;
  @override
  @JsonKey()
  List<WaterLog> get monthlyLogs {
    if (_monthlyLogs is EqualUnmodifiableListView) return _monthlyLogs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_monthlyLogs);
  }

  @override
  @JsonKey()
  final BeverageType selectedBeverage;

  /// 현재 선택된 음료의 "한 잔" 용량(ml). 가운데 박스는 이 값을 고정 표시.
  @override
  @JsonKey()
  final int servingMl;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'WaterViewState(todayLog: $todayLog, isUpdating: $isUpdating, hasUnsavedChanges: $hasUnsavedChanges, weeklyLogs: $weeklyLogs, monthlyLogs: $monthlyLogs, selectedBeverage: $selectedBeverage, servingMl: $servingMl, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaterViewStateImpl &&
            (identical(other.todayLog, todayLog) ||
                other.todayLog == todayLog) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            (identical(other.hasUnsavedChanges, hasUnsavedChanges) ||
                other.hasUnsavedChanges == hasUnsavedChanges) &&
            const DeepCollectionEquality().equals(
              other._weeklyLogs,
              _weeklyLogs,
            ) &&
            const DeepCollectionEquality().equals(
              other._monthlyLogs,
              _monthlyLogs,
            ) &&
            (identical(other.selectedBeverage, selectedBeverage) ||
                other.selectedBeverage == selectedBeverage) &&
            (identical(other.servingMl, servingMl) ||
                other.servingMl == servingMl) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    todayLog,
    isUpdating,
    hasUnsavedChanges,
    const DeepCollectionEquality().hash(_weeklyLogs),
    const DeepCollectionEquality().hash(_monthlyLogs),
    selectedBeverage,
    servingMl,
    errorMessage,
  );

  /// Create a copy of WaterViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaterViewStateImplCopyWith<_$WaterViewStateImpl> get copyWith =>
      __$$WaterViewStateImplCopyWithImpl<_$WaterViewStateImpl>(
        this,
        _$identity,
      );
}

abstract class _WaterViewState extends WaterViewState {
  const factory _WaterViewState({
    final WaterLog? todayLog,
    final bool isUpdating,
    final bool hasUnsavedChanges,
    final List<WaterLog> weeklyLogs,
    final List<WaterLog> monthlyLogs,
    final BeverageType selectedBeverage,
    final int servingMl,
    final String? errorMessage,
  }) = _$WaterViewStateImpl;
  const _WaterViewState._() : super._();

  @override
  WaterLog? get todayLog;
  @override
  bool get isUpdating;

  /// Firestore에 반영되지 않은 로컬 변경이 있음 (+/- 후 저장 전)
  @override
  bool get hasUnsavedChanges;
  @override
  List<WaterLog> get weeklyLogs;
  @override
  List<WaterLog> get monthlyLogs;
  @override
  BeverageType get selectedBeverage;

  /// 현재 선택된 음료의 "한 잔" 용량(ml). 가운데 박스는 이 값을 고정 표시.
  @override
  int get servingMl;
  @override
  String? get errorMessage;

  /// Create a copy of WaterViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaterViewStateImplCopyWith<_$WaterViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
