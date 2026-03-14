import 'package:google_sign_in/google_sign_in.dart';
import 'package:waterlogs/src/core/config/app_config.dart';

class GoogleAuthDataSource {

  final GoogleSignIn _googleSignIn;
  var serverClientId;

  GoogleAuthDataSource({required this.serverClientId})
    : _googleSignIn = GoogleSignIn(
        scopes: const ['email', 'profile'],
        serverClientId: AppConfig.googleServerClientId,
      );


  Future<String> getIdToken() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();

    if (account == null) {
      throw StateError('Google sign in cancelled');
    }

    final auth = await account.authentication;
    final idToken = auth.idToken;

    if (idToken == null || idToken.isEmpty) {
      throw StateError('Google idToken is null');
    }

    return idToken;
  }


  Future<void> logout() async {
    await _googleSignIn.signOut();
  }
}
