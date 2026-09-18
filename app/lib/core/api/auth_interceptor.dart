import 'dart:async';

import 'package:dio/dio.dart';

import 'token_store.dart';

/// Attaches the bearer token and transparently refreshes it on a 401.
///
/// Concurrent 401s share a single refresh future, so a screen that fires three
/// requests at once doesn't rotate the refresh token three times (which would
/// look like token replay to the server and sign the user out).
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokens,
    required this.refreshDio,
    required this.onSignedOut,
  });

  final TokenStore tokens;
  final Dio refreshDio;
  final VoidCallback onSignedOut;

  Future<bool>? _inFlight;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokens.accessToken;
    if (token != null && options.extra['skipAuth'] != true) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final isAuthCall = err.requestOptions.path.startsWith('/auth/');
    if (err.response?.statusCode != 401 || isAuthCall || tokens.refreshToken == null) {
      return handler.next(err);
    }

    final refreshed = await (_inFlight ??= _refresh().whenComplete(() => _inFlight = null));
    if (!refreshed) {
      onSignedOut();
      return handler.next(err);
    }

    try {
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      final retried = await refreshDio.fetch<dynamic>(options);
      return handler.resolve(retried);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  Future<bool> _refresh() async {
    try {
      final response = await refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': tokens.refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );
      final data = response.data!;
      await tokens.save(
        access: data['access_token'] as String,
        refresh: data['refresh_token'] as String,
      );
      return true;
    } catch (_) {
      await tokens.clear();
      return false;
    }
  }
}

typedef VoidCallback = void Function();
