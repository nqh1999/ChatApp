//
//  GoogleService.swift
//  ChatApp
//
//  Created by BeeTech on 22/12/2022.
//

import Foundation
import Firebase
import GoogleSignIn

class GoogleService {
    static let shared = GoogleService()
    
    func login(_ vc: LoginViewController, completed: @escaping (String, String, String) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: vc) { user, _ in
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken
                  else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { result, error in
                if error != nil { return }
                guard let result = result else { return }
                completed(result.user.displayName ?? "", result.user.uid, result.user.photoURL?.absoluteString ?? "")
            }
        }
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
            return
        }
    }
}
