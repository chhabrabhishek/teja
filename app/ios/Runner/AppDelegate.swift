import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var pendingTokenResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Required for the daily reminder to appear while Teja is in the foreground.
    UNUserNotificationCenter.current().delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    guard let messenger = engineBridge.pluginRegistry
      .registrar(forPlugin: "TejaPush")?.messenger() else { return }

    FlutterMethodChannel(name: "app.teja/push", binaryMessenger: messenger)
      .setMethodCallHandler { [weak self] call, result in
        guard call.method == "register" else {
          result(FlutterMethodNotImplemented)
          return
        }
        self?.registerForPush(result: result)
      }
  }

  /// Asks iOS for a device token; the callbacks below resolve the pending result.
  private func registerForPush(result: @escaping FlutterResult) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      guard settings.authorizationStatus == .authorized
              || settings.authorizationStatus == .provisional else {
        // No permission means no token. The caller treats nil as "unavailable".
        result(nil)
        return
      }
      DispatchQueue.main.async {
        self.pendingTokenResult = result
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    let token = deviceToken.map { String(format: "%02x", $0) }.joined()
    pendingTokenResult?(token)
    pendingTokenResult = nil
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    pendingTokenResult?(FlutterError(
      code: "apns_registration_failed",
      message: error.localizedDescription,
      details: nil
    ))
    pendingTokenResult = nil
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }
}
