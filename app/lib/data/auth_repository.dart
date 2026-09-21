import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../core/api/api_client.dart';
import '../core/api/token_store.dart';
import '../domain/models.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) {
  return TokenStore(const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  ));
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final tokens = ref.watch(tokenStoreProvider);
  return ApiClient(
    tokens: tokens,
    onSignedOut: () => ref.read(sessionRevokedProvider.notifier).state++,
  );
});

/// Bumped by the auth interceptor when a refresh fails. The router watches it.
final sessionRevokedProvider = StateProvider<int>((ref) => 0);

class AuthRepository {
  AuthRepository(this._api, this._tokens);

  final ApiClient _api;
  final TokenStore _tokens;

  Future<void> restore() => _tokens.load();

  Future<Session> signInWithApple({
    required String identityToken,
    String? nonce,
    String? fullName,
    String? timezone,
  }) =>
      _persist(_api.post<Map<String, dynamic>>(
        '/auth/apple',
        skipAuth: true,
        body: {
          'identity_token': identityToken,
          'nonce': nonce,
          'full_name': fullName,
          'timezone': timezone,
        },
      ));

  Future<void> requestEmailCode(String email) => _api.post<Map<String, dynamic>>(
        '/auth/email/request',
        skipAuth: true,
        body: {'email': email},
      );

  Future<Session> verifyEmailCode(String email, String code, String timezone) =>
      _persist(_api.post<Map<String, dynamic>>(
        '/auth/email/verify',
        skipAuth: true,
        body: {'email': email, 'code': code, 'timezone': timezone},
      ));

  Future<TejaUser> me() async =>
      TejaUser.fromJson(await _api.get<Map<String, dynamic>>('/me'));

  Future<TejaUser> updateMe(Map<String, dynamic> patch) async =>
      TejaUser.fromJson(await _api.patch<Map<String, dynamic>>('/me', body: patch));

  Future<void> deleteAccount() async {
    await _api.delete('/me');
    await _tokens.clear();
  }

  Future<void> signOut() async {
    final refresh = _tokens.refreshToken;
    if (refresh != null) {
      try {
        await _api.post<void>('/auth/logout', body: {'refresh_token': refresh});
      } catch (_) {
        // Signing out must never fail for the user.
      }
    }
    await _tokens.clear();
  }

  Future<Session> _persist(Future<Map<String, dynamic>> request) async {
    final session = Session.fromJson(await request);
    await _tokens.save(
      access: session.accessToken,
      refresh: session.refreshToken,
    );
    return session;
  }

  bool get hasSession => _tokens.hasSession;
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider), ref.watch(tokenStoreProvider));
});

/// The device's IANA zone, e.g. `Asia/Kolkata`.
///
/// The server uses this to decide when "today" ends, so it drives streaks as
/// well as the reminder. `DateTime.timeZoneName` returns an abbreviation like
/// `IST` which is ambiguous and not resolvable, hence the platform lookup.
Future<String> localTimezone() async {
  try {
    return await FlutterTimezone.getLocalTimezone();
  } catch (e) {
    if (kDebugMode) debugPrint('timezone lookup failed: $e');
    return 'UTC';
  }
}
