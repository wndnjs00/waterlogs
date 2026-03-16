import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 공통 Dio 클라이언트
final dioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: ''),
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
  );

  final dio = Dio(options);

  return dio;
});

