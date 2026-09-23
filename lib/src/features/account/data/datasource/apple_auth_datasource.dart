import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthDataSource {
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }

  /// Firebase `OAuthProvider('apple.com')`용 토큰 (iOS 전용)
  Future<({
    String idToken,
    String rawNonce,
    String authorizationCode,
    String? givenName,
    String? familyName,
    String? email,
  })> signInForFirebase() async {
    final rawNonce = _generateNonce();
    final hashedNonce = _sha256ofString(rawNonce);

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null || idToken.isEmpty) {
      throw StateError('Apple identityToken is null');
    }

    return (
      idToken: idToken,
      rawNonce: rawNonce,
      authorizationCode: credential.authorizationCode,
      givenName: credential.givenName,
      familyName: credential.familyName,
      email: credential.email,
    );
  }

  Future<void> logout() async {
    // Apple은 기기 세션 로그아웃 API가 없음. Firebase signOut만으로 충분.
  }
}
