import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "YanMataPermissionsPlugin") {
      let channel = FlutterMethodChannel(
        name: "com.yanmata.app/permissions",
        binaryMessenger: registrar.messenger()
      )
      channel.setMethodCallHandler { call, result in
        let center = UNUserNotificationCenter.current()
        switch call.method {
        case "checkNotificationPermission":
          center.getNotificationSettings { settings in
            DispatchQueue.main.async {
              switch settings.authorizationStatus {
              case .authorized, .provisional, .ephemeral:
                result("granted")
              case .denied:
                result("denied")
              case .notDetermined:
                result("not_determined")
              @unknown default:
                result("not_determined")
              }
            }
          }
        case "requestNotificationPermission":
          center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
              if granted {
                UIApplication.shared.registerForRemoteNotifications()
                result(true)
              } else {
                result(false)
              }
            }
          }
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }
}
