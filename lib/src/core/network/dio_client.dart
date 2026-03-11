import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 공통 Dio 클라이언트
///
/// - Kotlin 쪽에서 Retrofit + OkHttp 를 사용하는 위치에 대응
/// - 실제 baseUrl / 헤더 / 인터셉터 등은 추후 기능 구현 시 채워 넣는다.
final dioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: ''),
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
  );

  final dio = Dio(options);

  // TODO: 공통 인터셉터, 로그, 인증 토큰 주입 등 추가

  return dio;
});

