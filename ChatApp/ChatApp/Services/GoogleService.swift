//
//  GoogleService.swift
//  ChatApp
//
//  Created by BeeTech on 22/12/2022.
//

import Foundation
import Firebase
import GoogleSignIn
import RxSwift

class GoogleService {
    
    static let shared = GoogleService()
    private let firebaseAuth = Auth.auth()
    
    func login(_ vc: LoginViewController) -> Observable<(String, String, String)> {
        return Observable.create { [weak self] observer in
            guard let clientID = FirebaseApp.app()?.options.clientID else { return Disposables.create() }
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.signIn(with: config, presenting: vc) { user, _ in
                guard let authentication = user?.authentication,
                      let idToken = authentication.idToken
                      else { return }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                self?.firebaseAuth.signIn(with: credential) { result, error in
                    guard let result = result, error == nil else { return }
                    observer.onNext((result.user.displayName ?? "", result.user.uid, result.user.photoURL?.absoluteString ?? ""))
                }
            }
            return Disposables.create()
        }
    }
    
    func logout() {
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
            return
        }
    }
}
