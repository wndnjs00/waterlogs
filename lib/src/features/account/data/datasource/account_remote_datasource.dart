import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:waterlogs/src/core/util/firestore_paths.dart';

class AccountRemoteDataSource {
  AccountRemoteDataSource(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  static const _batchSize = 500;

  String? getCurrentUserId() => _auth.currentUser?.uid;
  String? getCurrentUserEmail() => _auth.currentUser?.email;

  // users/{uid} 문서와 하위 컬렉션 전체 삭제 (회원탈퇴)
  Future<void> deleteUserDocument(String uid) async {
    final userRef = _firestore.collection(FirestorePaths.users).doc(uid);

    final futures = <Future>[
      _deleteCollection(userRef.collection(FirestorePaths.waterLogs)),
      _deleteCollection(userRef.collection(FirestorePaths.badges)),
      _deleteCollection(userRef.collection(FirestorePaths.notifications)),
    ];

    // 병렬 실행
    await Future.wait(futures);
    // 사용자 문서 삭제
    await userRef.delete();
  }

  // 컬렉션 문서를 batch 단위로 삭제
  Future<void> _deleteCollection(
      CollectionReference<Map<String, dynamic>> collection) async {

    while (true) {
      final snapshot = await collection.limit(_batchSize).get();

      if (snapshot.docs.isEmpty) {
        break;
      }

      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    }
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