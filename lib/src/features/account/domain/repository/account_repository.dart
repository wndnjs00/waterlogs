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

  /// 카카오 액세스 토큰으로 Firebase 커스텀 토큰 로그인 후 UserInfo 저장
  Future<UserInfo> signInWithKakao(String accessToken);

  /// 네이버 액세스 토큰으로 Firebase 커스텀 토큰 로그인 후 UserInfo 저장
  Future<UserInfo> signInWithNaver(String accessToken);

  /// 구글 ID 토큰으로 Firebase 로그인 후 UserInfo 저장
  Future<UserInfo> signInWithGoogle(String idToken);

  // 자동 로그인용: 저장된 사용자 정보 로드
  Future<UserInfo?> loadUserFromFireStore();
}