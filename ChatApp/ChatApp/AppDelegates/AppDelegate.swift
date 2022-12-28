//
//  AppDelegate.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit
import FacebookCore
import ZaloSDK
import GoogleSignIn
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        ZaloSDK.sharedInstance().initialize(withAppId: Constant.ZALO_APP_ID)
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        GIDSignIn.sharedInstance.handle(url)
        ZDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        GIDSignIn.sharedInstance.handle(url)
        return true
    }
}
