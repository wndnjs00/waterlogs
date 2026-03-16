import '../model/user_info.dart';

abstract class AccountRepository {
  // 계정 정보 가져오기
  Stream<UserInfo?> getAccountInfo();

  // Firestore에 사용자 정보저장
  Future<void> saveUserInfo(UserInfo userInfo);

  Future<void> logout(LoginProvider? loginProvider);

  Future<UserInfo> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<UserInfo> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserInfo> signInWithKakao();

  Future<UserInfo> signInWithNaver();

  Future<UserInfo> signInWithGoogle();

  // 자동 로그인용: 저장된 사용자 정보 로드
  Future<UserInfo?> loadUserFromFireStore();

  // emailReauthPassword: 이메일 로그인할때만 사용(재인증용 비밀번호)
  Future<void> deleteAccount(
    LoginProvider loginProvider, {
    String? emailReauthPassword,
  });

  // FCM 토큰 저장 (push 알림용)
  Future<void> saveFcmToken(String token);
}