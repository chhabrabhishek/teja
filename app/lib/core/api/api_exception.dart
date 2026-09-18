import 'package:dio/dio.dart';

/// Every backend failure carries a stable `code`. The UI switches on the code and
/// shows copy written by a human — it never renders a raw server string, and it
/// never renders a stack trace.
class ApiException implements Exception {
  ApiException(this.message, {this.code = 'unknown', this.status = 0});

  final String message;
  final String code;
  final int status;

  bool get isOffline => code == 'offline';
  bool get isUnauthorized => status == 401;

  factory ApiException.from(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException(
        "You're offline. We'll keep your work safe.",
        code: 'offline',
      );
    }
    final data = e.response?.data;
    if (data is Map && data['detail'] is String) {
      return ApiException(
        data['detail'] as String,
        code: (data['code'] as String?) ?? 'error',
        status: e.response?.statusCode ?? 0,
      );
    }
    return ApiException(
      'Something went wrong. Try again in a moment.',
      code: 'error',
      status: e.response?.statusCode ?? 0,
    );
  }

  @override
  String toString() => 'ApiException($code): $message';
}
