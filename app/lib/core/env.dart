/// Build-time configuration:
/// `flutter run --dart-define=DABBLE_API_BASE=http://localhost:8000/api/v1`
abstract final class Env {
  static const apiBase = String.fromEnvironment(
    'DABBLE_API_BASE',
    defaultValue:
        'https://main-bvxea6i-q6k7ce43roozq.de-2.platformsh.site/api/v1',
  );

  static const appStoreUrl = String.fromEnvironment(
    'DABBLE_APP_URL',
    defaultValue: 'https://dabble.app',
  );

  static const appleServiceId = String.fromEnvironment('DABBLE_APPLE_SERVICE_ID');
}
