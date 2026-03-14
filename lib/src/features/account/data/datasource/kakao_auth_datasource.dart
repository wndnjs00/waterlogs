import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoAuthDataSource {
  Future<String> getAccessToken() async {
    try {

      bool installed = await isKakaoTalkInstalled();

      OAuthToken token;

      if (installed) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      return token.accessToken;

    } catch (e) {
      throw StateError('Kakao login failed: $e');
    }
  }

  Future<void> logout() async {
    await UserApi.instance.logout();
  }
}

