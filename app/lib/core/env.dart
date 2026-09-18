/// Build-time configuration:
/// `flutter run --dart-define=TEJA_API_BASE=https://api.teja.app/api/v1`
abstract final class Env {
  static const apiBase = String.fromEnvironment(
    'TEJA_API_BASE',
    // iOS Simulator can reach the host machine on localhost.
    defaultValue: 'http://localhost:8000/api/v1',
  );

  static const appStoreUrl = String.fromEnvironment(
    'TEJA_APP_URL',
    defaultValue: 'https://teja.app',
  );

  static const appleServiceId = String.fromEnvironment('TEJA_APPLE_SERVICE_ID');
}
