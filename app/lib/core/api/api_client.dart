import 'dart:io';

import 'package:dio/dio.dart';

import '../env.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';
import 'token_store.dart';

/// The only thing in the app that knows about HTTP.
class ApiClient {
  ApiClient({required this.tokens, required void Function() onSignedOut}) {
    final options = BaseOptions(
      baseUrl: Env.apiBase,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 20),
      contentType: Headers.jsonContentType,
      headers: {'X-Device': Platform.operatingSystem},
    );
    _dio = Dio(options);
    _refreshDio = Dio(options);
    _dio.interceptors.add(AuthInterceptor(
      tokens: tokens,
      refreshDio: _refreshDio,
      onSignedOut: onSignedOut,
    ));
  }

  final TokenStore tokens;
  late final Dio _dio;
  late final Dio _refreshDio;

  Future<T> get<T>(String path, {Map<String, dynamic>? query}) =>
      _run(() => _dio.get<T>(path, queryParameters: query));

  Future<T> post<T>(String path, {Object? body, bool skipAuth = false}) => _run(
        () => _dio.post<T>(
          path,
          data: body,
          options: Options(extra: {'skipAuth': skipAuth}),
        ),
      );

  Future<T> put<T>(String path, {Object? body}) => _run(() => _dio.put<T>(path, data: body));

  Future<T> patch<T>(String path, {Object? body}) =>
      _run(() => _dio.patch<T>(path, data: body));

  Future<void> delete(String path, {Object? body}) =>
      _run(() => _dio.delete<dynamic>(path, data: body));

  /// Media goes straight to the bucket with a presigned URL — it never passes
  /// through our API server.
  Future<void> uploadBytes({
    required String url,
    required List<int> bytes,
    required Map<String, String> headers,
    void Function(double progress)? onProgress,
  }) async {
    try {
      await Dio().put<void>(
        url,
        data: Stream.fromIterable([bytes]),
        options: Options(
          headers: {...headers, Headers.contentLengthHeader: bytes.length},
        ),
        onSendProgress: (sent, total) =>
            onProgress?.call(total <= 0 ? 0 : sent / total),
      );
    } on DioException catch (e) {
      throw ApiException.from(e);
    }
  }

  Future<T> _run<T>(Future<Response<T>> Function() request) async {
    try {
      final response = await request();
      return response.data as T;
    } on DioException catch (e) {
      throw ApiException.from(e);
    }
  }
}
