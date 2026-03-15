import '../model/user_info.dart';
import '../repository/account_repository.dart';

class AuthUseCase {

  final AccountRepository repository;

  AuthUseCase(this.repository);

  Future<UserInfo> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) {
    return repository.signUpWithEmail(
      email: email,
      password: password,
      name: name,
    );
  }

  Future<UserInfo> signInWithEmail({
    required String email,
    required String password,
  }) {
    return repository.signInWithEmail(
      email: email,
      password: password,
    );
  }

  Future<UserInfo> signInWithKakao() {
    return repository.signInWithKakao();
  }

  Future<UserInfo> signInWithNaver() {
    return repository.signInWithNaver();
  }

  Future<UserInfo> signInWithGoogle() {
    return repository.signInWithGoogle();
  }
}
