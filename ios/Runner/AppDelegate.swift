import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyD7KZ3dujsZuhVn8E0uagRyQ65_YvpGJcM")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
