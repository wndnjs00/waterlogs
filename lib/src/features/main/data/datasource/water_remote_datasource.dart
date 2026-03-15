import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/water_log_dto.dart';

class WaterRemoteDataSource {
  WaterRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  static const _users = 'users';
  static const _waterLogs = 'water_logs';

  Future<WaterLogDto?> getTodayLog(String uid, String date) async {
    final snapshot = await _firestore
        .collection(_users)
        .doc(uid)
        .collection(_waterLogs)
        .doc(date)
        .get();

    if (!snapshot.exists || snapshot.data() == null) return null;
    return WaterLogDto.fromJson({'date': snapshot.id, ...?snapshot.data()});
  }

  Future<void> setWaterLog(String uid, WaterLogDto dto) async {
    final docRef = _firestore
        .collection(_users)
        .doc(uid)
        .collection(_waterLogs)
        .doc(dto.date);

    await docRef.set(dto.toJson());
  }

  Future<List<WaterLogDto>> getLogsInRange(
    String uid,
    String start,
    String end,
  ) async {
    final snapshot = await _firestore
        .collection(_users)
        .doc(uid)
        .collection(_waterLogs)
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: start)
        .where(FieldPath.documentId, isLessThanOrEqualTo: end)
        .get();

    return snapshot.docs.map((doc) {
      return WaterLogDto.fromJson({'date': doc.id, ...?doc.data()});
    }).toList();
  }
}
