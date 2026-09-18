import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Tokens live in the iOS Keychain, never in SharedPreferences.
class TokenStore {
  TokenStore(this._storage);

  final FlutterSecureStorage _storage;

  static const _access = 'teja.access';
  static const _refresh = 'teja.refresh';

  String? accessToken;
  String? refreshToken;

  Future<void> load() async {
    accessToken = await _storage.read(key: _access);
    refreshToken = await _storage.read(key: _refresh);
  }

  Future<void> save({required String access, required String refresh}) async {
    accessToken = access;
    refreshToken = refresh;
    await _storage.write(key: _access, value: access);
    await _storage.write(key: _refresh, value: refresh);
  }

  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
    await _storage.delete(key: _access);
    await _storage.delete(key: _refresh);
  }

  bool get hasSession => refreshToken != null;
}
