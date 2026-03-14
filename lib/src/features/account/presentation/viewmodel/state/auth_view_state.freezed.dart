// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthViewState {
  UserInfo? get user => throw _privateConstructorUsedError;
  EmailAuthState get signUpState => throw _privateConstructorUsedError;
  EmailAuthState get signInState => throw _privateConstructorUsedError;

  /// Create a copy of AuthViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthViewStateCopyWith<AuthViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthViewStateCopyWith<$Res> {
  factory $AuthViewStateCopyWith(
    AuthViewState value,
    $Res Function(AuthViewState) then,
  ) = _$AuthViewStateCopyWithImpl<$Res, AuthViewState>;
  @useResult
  $Res call({
    UserInfo? user,
    EmailAuthState signUpState,
    EmailAuthState signInState,
  });

  $UserInfoCopyWith<$Res>? get user;
  $EmailAuthStateCopyWith<$Res> get signUpState;
  $EmailAuthStateCopyWith<$Res> get signInState;
}

/// @nodoc
class _$AuthViewStateCopyWithImpl<$Res, $Val extends AuthViewState>
    implements $AuthViewStateCopyWith<$Res> {
  _$AuthViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? signUpState = null,
    Object? signInState = null,
  }) {
    return _then(
      _value.copyWith(
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserInfo?,
            signUpState: null == signUpState
                ? _value.signUpState
                : signUpState // ignore: cast_nullable_to_non_nullable
                      as EmailAuthState,
            signInState: null == signInState
                ? _value.signInState
                : signInState // ignore: cast_nullable_to_non_nullable
                      as EmailAuthState,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserInfoCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserInfoCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of AuthViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EmailAuthStateCopyWith<$Res> get signUpState {
    return $EmailAuthStateCopyWith<$Res>(_value.signUpState, (value) {
      return _then(_value.copyWith(signUpState: value) as $Val);
    });
  }

  /// Create a copy of AuthViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EmailAuthStateCopyWith<$Res> get signInState {
    return $EmailAuthStateCopyWith<$Res>(_value.signInState, (value) {
      return _then(_value.copyWith(signInState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthViewStateImplCopyWith<$Res>
    implements $AuthViewStateCopyWith<$Res> {
  factory _$$AuthViewStateImplCopyWith(
    _$AuthViewStateImpl value,
    $Res Function(_$AuthViewStateImpl) then,
  ) = __$$AuthViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    UserInfo? user,
    EmailAuthState signUpState,
    EmailAuthState signInState,
  });

  @override
  $UserInfoCopyWith<$Res>? get user;
  @override
  $EmailAuthStateCopyWith<$Res> get signUpState;
  @override
  $EmailAuthStateCopyWith<$Res> get signInState;
}

/// @nodoc
class __$$AuthViewStateImplCopyWithImpl<$Res>
    extends _$AuthViewStateCopyWithImpl<$Res, _$AuthViewStateImpl>
    implements _$$AuthViewStateImplCopyWith<$Res> {
  __$$AuthViewStateImplCopyWithImpl(
    _$AuthViewStateImpl _value,
    $Res Function(_$AuthViewStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? signUpState = null,
    Object? signInState = null,
  }) {
    return _then(
      _$AuthViewStateImpl(
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserInfo?,
        signUpState: null == signUpState
            ? _value.signUpState
            : signUpState // ignore: cast_nullable_to_non_nullable
                  as EmailAuthState,
        signInState: null == signInState
            ? _value.signInState
            : signInState // ignore: cast_nullable_to_non_nullable
                  as EmailAuthState,
      ),
    );
  }
}

/// @nodoc

class _$AuthViewStateImpl extends _AuthViewState {
  const _$AuthViewStateImpl({
    this.user,
    this.signUpState = EmailAuthState.idle,
    this.signInState = EmailAuthState.idle,
  }) : super._();

  @override
  final UserInfo? user;
  @override
  @JsonKey()
  final EmailAuthState signUpState;
  @override
  @JsonKey()
  final EmailAuthState signInState;

  @override
  String toString() {
    return 'AuthViewState(user: $user, signUpState: $signUpState, signInState: $signInState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthViewStateImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.signUpState, signUpState) ||
                other.signUpState == signUpState) &&
            (identical(other.signInState, signInState) ||
                other.signInState == signInState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, signUpState, signInState);

  /// Create a copy of AuthViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthViewStateImplCopyWith<_$AuthViewStateImpl> get copyWith =>
      __$$AuthViewStateImplCopyWithImpl<_$AuthViewStateImpl>(this, _$identity);
}

abstract class _AuthViewState extends AuthViewState {
  const factory _AuthViewState({
    final UserInfo? user,
    final EmailAuthState signUpState,
    final EmailAuthState signInState,
  }) = _$AuthViewStateImpl;
  const _AuthViewState._() : super._();

  @override
  UserInfo? get user;
  @override
  EmailAuthState get signUpState;
  @override
  EmailAuthState get signInState;

  /// Create a copy of AuthViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthViewStateImplCopyWith<_$AuthViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
