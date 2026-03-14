import 'package:naver_login_sdk/naver_login_sdk.dart';

class NaverAuthDataSource {

  Future<String> getAccessToken() async {

    final result = await NaverLoginSDK.login();

    if (result != true) {
      throw StateError('Naver login cancelled');
    }

    final token = await NaverLoginSDK.getAccessToken();

    if (token.isEmpty) {
      throw StateError('Naver token empty');
    }

    return token;
  }

  Future<void> logout() async {
    await NaverLoginSDK.logout();
  }
}
