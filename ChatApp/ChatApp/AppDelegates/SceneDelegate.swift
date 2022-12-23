//
//  SceneDelegate.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import IQKeyboardManager

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: LoginViewController())
        self.window = window
        window.makeKeyAndVisible()
        IQKeyboardManager.shared().isEnabled = true
    }
}

