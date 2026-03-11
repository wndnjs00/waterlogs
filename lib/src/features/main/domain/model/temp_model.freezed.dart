// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'temp_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TempModel _$TempModelFromJson(Map<String, dynamic> json) {
  return _TempModel.fromJson(json);
}

/// @nodoc
mixin _$TempModel {
  String get name => throw _privateConstructorUsedError;

  /// Serializes this TempModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TempModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TempModelCopyWith<TempModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TempModelCopyWith<$Res> {
  factory $TempModelCopyWith(TempModel value, $Res Function(TempModel) then) =
      _$TempModelCopyWithImpl<$Res, TempModel>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$TempModelCopyWithImpl<$Res, $Val extends TempModel>
    implements $TempModelCopyWith<$Res> {
  _$TempModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TempModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TempModelImplCopyWith<$Res>
    implements $TempModelCopyWith<$Res> {
  factory _$$TempModelImplCopyWith(
    _$TempModelImpl value,
    $Res Function(_$TempModelImpl) then,
  ) = __$$TempModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$TempModelImplCopyWithImpl<$Res>
    extends _$TempModelCopyWithImpl<$Res, _$TempModelImpl>
    implements _$$TempModelImplCopyWith<$Res> {
  __$$TempModelImplCopyWithImpl(
    _$TempModelImpl _value,
    $Res Function(_$TempModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TempModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _$TempModelImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TempModelImpl implements _TempModel {
  const _$TempModelImpl({required this.name});

  factory _$TempModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TempModelImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'TempModel(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TempModelImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of TempModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TempModelImplCopyWith<_$TempModelImpl> get copyWith =>
      __$$TempModelImplCopyWithImpl<_$TempModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TempModelImplToJson(this);
  }
}

abstract class _TempModel implements TempModel {
  const factory _TempModel({required final String name}) = _$TempModelImpl;

  factory _TempModel.fromJson(Map<String, dynamic> json) =
      _$TempModelImpl.fromJson;

  @override
  String get name;

  /// Create a copy of TempModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TempModelImplCopyWith<_$TempModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
