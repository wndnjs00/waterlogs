enum EmailAuthStatus { idle, loading, success, error }

class EmailAuthState {
  const EmailAuthState(this.status, [this.message]);

  final EmailAuthStatus status;
  final String? message;

  static const idle = EmailAuthState(EmailAuthStatus.idle);
  static const loading = EmailAuthState(EmailAuthStatus.loading);
  static const success = EmailAuthState(EmailAuthStatus.success);

  EmailAuthState copyWith({
    EmailAuthStatus? status,
    String? message,
  }) {
    return EmailAuthState(
      status ?? this.status,
      message ?? this.message,
    );
  }
}