import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_client.dart';
import 'auth_repository.dart';

/// APNs device-token plumbing.
///
/// Native registration rather than Firebase: the whole job is "hand a hex token
/// to our own server", and an entire Google SDK for that is a poor trade.
class PushRepository {
  PushRepository(this._api);

  static const _channel = MethodChannel('app.teja/push');

  final ApiClient _api;
  String? _registeredToken;

  /// Asks iOS to register for remote notifications and returns the token.
  /// Null when the user declined or the capability is missing from the build.
  Future<String?> obtainToken() async {
    try {
      return await _channel.invokeMethod<String>('register');
    } on PlatformException catch (e) {
      if (kDebugMode) debugPrint('APNs registration failed: ${e.message}');
      return null;
    } on MissingPluginException {
      if (kDebugMode) debugPrint('APNs channel unavailable on this platform');
      return null;
    }
  }

  Future<void> syncToken({String? appVersion}) async {
    final token = await obtainToken();
    if (token == null || token == _registeredToken) return;
    try {
      await _api.post<void>('/me/devices', body: {
        'token': token,
        'platform': 'ios',
        'app_version': appVersion ?? '',
      });
      _registeredToken = token;
    } catch (e) {
      // A failed registration must never block the app; retried next launch.
      if (kDebugMode) debugPrint('device registration failed: $e');
    }
  }

  Future<void> unregister() async {
    final token = _registeredToken;
    if (token == null) return;
    try {
      await _api.delete('/me/devices/$token');
    } catch (_) {
      // Signing out must never fail for the user.
    }
    _registeredToken = null;
  }
}

final pushRepositoryProvider = Provider<PushRepository>(
  (ref) => PushRepository(ref.watch(apiClientProvider)),
);
