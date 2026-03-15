import '../model/user_info.dart';
import '../repository/account_repository.dart';

class AccountUseCase {

  final AccountRepository repository;

  AccountUseCase(this.repository);

  Future<void> logout(LoginProvider? provider) {
    return repository.logout(provider);
  }

  Future<void> deleteAccount(
      LoginProvider provider, {
        String? emailReauthPassword,
      }) {
    return repository.deleteAccount(
      provider,
      emailReauthPassword: emailReauthPassword,
    );
  }

  Future<UserInfo?> loadUser() {
    return repository.loadUserFromFireStore();
  }

  Stream<UserInfo?> getAccountInfo() {
    return repository.getAccountInfo();
  }
}
