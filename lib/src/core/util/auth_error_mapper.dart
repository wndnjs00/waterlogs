import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// 앱 전역 예외를 사용자에게 보여줄 토스트 메시지로 변환
abstract class AuthErrorMapper {
  AuthErrorMapper._();

  // 일반 로그인/회원가입/저장 실패 시 사용
  static String map(Object e) {
    // 네트워크 연결 없음 -> 와이파이 OFF
    if (_isNetworkError(e)) return '네트워크 연결 상태가 좋지 않습니다';

    // Firebase Timeout / 서버지연
    if (_isTimeout(e)) return '서버 지연';

    if (e is FirebaseAuthException) {
      switch (e.code) {
        // Firebase 이메일 없음(미가입) -> 가입 안된 계정
        case 'user-not-found':
        case 'user-disabled':
          return '가입 안된 계정';
        // 이메일/비밀번호 오류, 이미 가입된 이메일 회원가입 시 -> 잘못된 계정입니다
        case 'wrong-password':
        case 'invalid-credential':
        case 'invalid-email':
        case 'email-already-in-use': // 이미 있는 이메일로 회원가입
        case 'weak-password':
          return '잘못된 계정입니다';
        // Firebase Auth 오류 -> 토큰 문제
        default:
          return '토큰 문제';
      }
    }
    // Firestore 실패 -> DB 저장 실패
    if (_isFirestoreException(e)) return 'DB 저장 실패';
    // 회원탈퇴 실패 -> unlick 오류
    if (_isUnlinkError(e)) return 'unlink 오류';
    return '기타 오류';
  }

  /// 물 기록 저장/로드 실패 시 사용
  static String mapForWaterUpdate(Object e) {
    if (_isNetworkError(e)) return '네트워크 연결 상태가 좋지 않습니다';
    return map(e);
  }

  /// 알림(FCM/Firestore) 관련 오류 시 사용
  static String mapForNotification(Object e) {
    if (_isNetworkError(e)) return '네트워크 연결 상태가 좋지 않습니다';
    if (_isTimeout(e)) return '서버 지연';
    if (_isFirestoreException(e)) return '알림을 불러오지 못했습니다';
    return '알림 처리 중 오류가 발생했습니다';
  }

  /// 뱃지(Firestore 구독) 관련 오류 시 사용
  static String mapForBadge(Object e) {
    if (_isNetworkError(e)) return '네트워크 연결 상태가 좋지 않습니다';
    if (_isTimeout(e)) return '서버 지연';
    if (_isFirestoreException(e)) return '뱃지를 불러오지 못했습니다';
    return '뱃지 처리 중 오류가 발생했습니다';
  }

  /// OAuth(Google/Kakao/Naver) 로그인 실패 시 사용
  static String mapForOAuth(Object e) {
    if (_isNetworkError(e)) return '네트워크 연결 상태가 좋지 않습니다';
    if (_isTimeout(e)) return '서버 지연';
    if (e is FirebaseAuthException) return '토큰 문제';
    if (_isFirestoreException(e)) return 'DB 저장 실패';
    return '로그인 실패';
  }

  static bool _isNetworkError(Object e) {
    if (e is SocketException) return true;
    if (e is OSError && (e.message.contains('Network is unreachable') || e.message.contains('Connection'))) return true;
    if (e is FirebaseAuthException && e.code == 'network-request-failed') return true;
    if (e is FirebaseException && e.code == 'unavailable') return true;
    if (e is DioException) {
      return e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown;
    }
    return false;
  }

  static bool _isTimeout(Object e) {
    if (e is TimeoutException) return true;
    if (e is DioException) {
      return e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout;
    }
    final msg = e.toString().toLowerCase();
    if (msg.contains('timeout') || msg.contains('timed out')) return true;
    return false;
  }

  static bool _isUnlinkError(Object e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('unlink') || msg.contains('회원탈퇴');
  }

  static bool _isFirestoreException(Object e) {
    if (e is FirebaseException && e.plugin == 'cloud_firestore') {
      return true;
    }
    return false;
  }

}
