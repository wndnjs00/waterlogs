import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waterlogs/src/features/account/domain/model/user_info.dart';
import 'package:waterlogs/src/features/account/presentation/viewmodel/state/email_auth_state.dart';

part 'auth_view_state.freezed.dart';

@freezed
class AuthViewState with _$AuthViewState {
  const factory AuthViewState({
    UserInfo? user,
    @Default(EmailAuthState.idle) EmailAuthState signUpState,
    @Default(EmailAuthState.idle) EmailAuthState signInState,
  }) = _AuthViewState;

  const AuthViewState._();

  static const initial = AuthViewState();
}