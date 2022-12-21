//
//  AppDelegate.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import FirebaseCore
import UIKit
import FacebookCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        return true
    }
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
//    func application(
//            _ application: UIApplication,
//            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//        ) -> Bool {
//            
//            
////            self.window = UIWindow(frame: UIScreen.main.bounds)
////            self.window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
////            window?.makeKeyAndVisible()
//
//            ApplicationDelegate.shared.application(
//                application,
//                didFinishLaunchingWithOptions: launchOptions
//            )
//            
//            return true
//        }
//              
        func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        }
}

