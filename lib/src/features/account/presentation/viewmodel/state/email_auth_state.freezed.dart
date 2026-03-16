// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EmailAuthState {
  EmailAuthStatus get status => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Create a copy of EmailAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmailAuthStateCopyWith<EmailAuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailAuthStateCopyWith<$Res> {
  factory $EmailAuthStateCopyWith(
    EmailAuthState value,
    $Res Function(EmailAuthState) then,
  ) = _$EmailAuthStateCopyWithImpl<$Res, EmailAuthState>;
  @useResult
  $Res call({EmailAuthStatus status, String? message});
}

/// @nodoc
class _$EmailAuthStateCopyWithImpl<$Res, $Val extends EmailAuthState>
    implements $EmailAuthStateCopyWith<$Res> {
  _$EmailAuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmailAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? message = freezed}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as EmailAuthStatus,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmailAuthStateImplCopyWith<$Res>
    implements $EmailAuthStateCopyWith<$Res> {
  factory _$$EmailAuthStateImplCopyWith(
    _$EmailAuthStateImpl value,
    $Res Function(_$EmailAuthStateImpl) then,
  ) = __$$EmailAuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({EmailAuthStatus status, String? message});
}

/// @nodoc
class __$$EmailAuthStateImplCopyWithImpl<$Res>
    extends _$EmailAuthStateCopyWithImpl<$Res, _$EmailAuthStateImpl>
    implements _$$EmailAuthStateImplCopyWith<$Res> {
  __$$EmailAuthStateImplCopyWithImpl(
    _$EmailAuthStateImpl _value,
    $Res Function(_$EmailAuthStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmailAuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? message = freezed}) {
    return _then(
      _$EmailAuthStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as EmailAuthStatus,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$EmailAuthStateImpl extends _EmailAuthState {
  const _$EmailAuthStateImpl({this.status = EmailAuthStatus.idle, this.message})
    : super._();

  @override
  @JsonKey()
  final EmailAuthStatus status;
  @override
  final String? message;

  @override
  String toString() {
    return 'EmailAuthState(status: $status, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailAuthStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, message);

  /// Create a copy of EmailAuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailAuthStateImplCopyWith<_$EmailAuthStateImpl> get copyWith =>
      __$$EmailAuthStateImplCopyWithImpl<_$EmailAuthStateImpl>(
        this,
        _$identity,
      );
}

abstract class _EmailAuthState extends EmailAuthState {
  const factory _EmailAuthState({
    final EmailAuthStatus status,
    final String? message,
  }) = _$EmailAuthStateImpl;
  const _EmailAuthState._() : super._();

  @override
  EmailAuthStatus get status;
  @override
  String? get message;

  /// Create a copy of EmailAuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmailAuthStateImplCopyWith<_$EmailAuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
