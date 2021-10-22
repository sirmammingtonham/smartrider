import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
         let nsDictionary = NSDictionary(contentsOfFile: path)
         if let apiKey = nsDictionary?["API_KEY"] as? String {
             GMSServices.provideAPIKey(apiKey)
         }
     }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
