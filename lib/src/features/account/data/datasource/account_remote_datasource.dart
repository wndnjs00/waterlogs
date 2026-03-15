import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:waterlogs/src/core/util/firestore_paths.dart';

/// 회원탈퇴 시 Firestore 사용자 문서 삭제 및 Firebase Auth 재인증/삭제 담당.
/// Repository는 이 DataSource만 호출하고, Firestore/Auth 직접 사용하지 않음.
class AccountRemoteDataSource {
  AccountRemoteDataSource(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String? getCurrentUserId() => _auth.currentUser?.uid;
  String? getCurrentUserEmail() => _auth.currentUser?.email;

  Future<void> deleteUserDocument(String uid) async {
    await _firestore
        .collection(FirestorePaths.users)
        .doc(uid)
        .delete();
  }

  // 이메일 회원탈퇴 시 재인증
  Future<void> reauthenticateWithEmail({
    required String email,
    required String password,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('currentUser is null');
    }
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }

  // Firebase Auth 현재 사용자 삭제
  Future<void> deleteCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('currentUser is null');
    }
    await user.delete();
  }
}