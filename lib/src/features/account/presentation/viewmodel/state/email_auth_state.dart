import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_auth_state.freezed.dart';

enum EmailAuthStatus { idle, loading, success, error }

@freezed
class EmailAuthState with _$EmailAuthState {
  const factory EmailAuthState({
    @Default(EmailAuthStatus.idle) EmailAuthStatus status,
    String? message,
  }) = _EmailAuthState;

  const EmailAuthState._();

  static const idle = EmailAuthState(status: EmailAuthStatus.idle);
  static const loading = EmailAuthState(status: EmailAuthStatus.loading);
  static const success = EmailAuthState(status: EmailAuthStatus.success);
}