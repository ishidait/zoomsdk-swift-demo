//
//  AppDelegate.swift
//  ZoomDemo
//
//  Created by Makoto Ishida on 11/15/20.
//

import UIKit
import MobileRTC
import MobileCoreServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MobileRTCAuthDelegate {

    let clientKey       = "YOUR_SDK_KEY"
    let clientSecret    = "YOUR_SDK_SECRET"

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        return true
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navigationController = UINavigationController(rootViewController: newViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        
        let context = MobileRTCSDKInitContext()
        context.domain = "zoom.us"
        context.enableLog = true
        MobileRTC.shared().initialize(context)
        print(MobileRTC.shared().mobileRTCVersion() ?? "")

        MobileRTC.shared().setMobileRTCRootController(navigationController)

        let authService = MobileRTC.shared().getAuthService()
        if (authService != nil) {
            authService!.delegate        = self
            authService!.clientKey       = clientKey
            authService!.clientSecret    = clientSecret
            authService!.sdkAuth()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        print(returnValue)
        if (returnValue != MobileRTCAuthError_Success) {
           let msg = "SDK authentication failed, error code: \(returnValue)"
            print(msg)
        }
    }

}

