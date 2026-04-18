import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthDataSource {

  final GoogleSignIn _googleSignIn;

  GoogleAuthDataSource({required String serverClientId})
    : _googleSignIn = GoogleSignIn(
        scopes: const ['email', 'profile'],
        serverClientId: serverClientId,
      );

  /// Firebase `GoogleAuthProvider.credential`용 토큰. [serverClientId]는 웹 클라이언트 ID여야 [idToken]이 나온다.
  Future<({String idToken, String? accessToken})> signInForFirebase() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();

    if (account == null) {
      throw StateError('Google sign in cancelled');
    }

    final auth = await account.authentication;
    final idToken = auth.idToken;

    if (idToken == null || idToken.isEmpty) {
      throw StateError(
        'Google idToken is null — .env의 GOOGLE_SERVER_CLIENT_ID가 '
        'Firebase 콘솔의 웹 OAuth 클라이언트 ID와 같은지 확인하세요',
      );
    }

    return (idToken: idToken, accessToken: auth.accessToken);
  }


  Future<void> logout() async {
    await _googleSignIn.signOut();
  }
}
