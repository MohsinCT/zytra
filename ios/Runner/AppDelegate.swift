import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ─── Google Maps SDK Initialization ────────────────────────────────────
    // The API key is stored in Info.plist under the key "GMSApiKey".
    // This pattern keeps the key in one place and out of source code,
    // making it easy to swap per build configuration (Debug/Release).
    //
    // To update the key: open ios/Runner/Info.plist and edit the
    // value for the "GMSApiKey" key.
    // ──────────────────────────────────────────────────────────────────────
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String,
       !apiKey.isEmpty,
       !apiKey.hasPrefix("YOUR_") {
      GMSServices.provideAPIKey(apiKey)
    } else {
      // Log a clear, developer-readable error. The app will continue but
      // the map will render with a "For development purposes only" overlay
      // on real devices. Replace the key in Info.plist to fix this.
      print("""
        ⚠️  [Zytra] Google Maps API Key is missing or still a placeholder.
            Open ios/Runner/Info.plist and set a real value for "GMSApiKey".
            Maps will NOT render correctly on real devices without a valid key.
        """)
      // Provide an empty string to avoid a nil-crash — SDK will show
      // a watermark but won't crash the app.
      GMSServices.provideAPIKey("")
    }

    // super.application must be called AFTER provideAPIKey so that
    // the Flutter engine and all plugins (including google_maps_flutter)
    // initialise with the SDK already ready.
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
