import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterlogs/src/core/util/auth_error_mapper.dart';

void main() {
  group('AuthErrorMapper - 서버 지연', () {
    group('map()', () {
      test('TimeoutException이면 "서버 지연"을 반환한다', () {
        expect(
          AuthErrorMapper.map(TimeoutException('Operation timed out')),
          '서버 지연',
        );
      });

      test('DioException(receiveTimeout)이면 "서버 지연"을 반환한다', () {
        final e = DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.receiveTimeout,
        );
        expect(AuthErrorMapper.map(e), '서버 지연');
      });

      test('DioException(sendTimeout)이면 "서버 지연"을 반환한다', () {
        final e = DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.sendTimeout,
        );
        expect(AuthErrorMapper.map(e), '서버 지연');
      });

      test('메시지에 "timeout"이 포함된 Exception이면 "서버 지연"을 반환한다', () {
        expect(
          AuthErrorMapper.map(Exception('Connection timeout occurred')),
          '서버 지연',
        );
      });

      test('메시지에 "timed out"이 포함된 Exception이면 "서버 지연"을 반환한다', () {
        expect(
          AuthErrorMapper.map(Exception('Request timed out')),
          '서버 지연',
        );
      });
    });

    group('mapForWaterUpdate()', () {
      test('TimeoutException이면 "서버 지연"을 반환한다', () {
        expect(
          AuthErrorMapper.mapForWaterUpdate(TimeoutException('')),
          '서버 지연',
        );
      });

      test('DioException(receiveTimeout)이면 "서버 지연"을 반환한다', () {
        final e = DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.receiveTimeout,
        );
        expect(AuthErrorMapper.mapForWaterUpdate(e), '서버 지연');
      });
    });

    group('mapForOAuth()', () {
      test('TimeoutException이면 "서버 지연"을 반환한다', () {
        expect(
          AuthErrorMapper.mapForOAuth(TimeoutException('')),
          '서버 지연',
        );
      });

      test('DioException(sendTimeout)이면 "서버 지연"을 반환한다', () {
        final e = DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.sendTimeout,
        );
        expect(AuthErrorMapper.mapForOAuth(e), '서버 지연');
      });
    });
  });
}
