import UIKit
import Flutter

enum MyFlutterErrorCode {
    static let unavailable = "UNAVAILABLE"
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    private let coordintor = CommandCoordinator()
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            GeneratedPluginRegistrant.register(with: self)
            guard let vc = window?.rootViewController as? FlutterViewController else {
                fatalError("rootViewController is not type FlutterViewController")
            }
            let channel = BTChannel()
            coordintor.setupFlutterCommunication(channel: channel, in: vc)
            
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
