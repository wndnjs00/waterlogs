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

  // 네이버 연동 해제 (회원탈퇴 시 호출)
  Future<void> signout() async {
    await NaverLoginSDK.logout(isForced: true);
  }
}
