import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
    // let plist = NSDictionary(contentsOfFile:filePath!)
    // let value = plist?.object(forKey: "GOOG_API_KEY") as! String
    // NSString* mapsApiKey = [[NSProcessInfo processInfo] environment[@"MAPS_API_KEY"];
    let mapsApiKey = [[NSProcessInfo processInfo] environment[@"MAPS_API_KEY"]; // needs work, idk how to translate this line to swift
    GMSServices.provideAPIKey(mapsApiKey)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
