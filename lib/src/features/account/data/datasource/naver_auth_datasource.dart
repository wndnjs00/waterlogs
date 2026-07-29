import 'package:naver_login_sdk/naver_login_sdk.dart';

class NaverAuthDataSource {

  Future<String> getAccessToken() async {
    String? failCode;
    String? failMessage;

    final result = await NaverLoginSDK.login(
      callback: OAuthLoginCallback(
        onSuccess: () {},
        onFailure: (httpStatus, message) {
          failCode = httpStatus;
          failMessage = message;
        },
      ),
    );

    if (result != true) {
      throw StateError('Naver fail: code=$failCode msg=$failMessage');
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
