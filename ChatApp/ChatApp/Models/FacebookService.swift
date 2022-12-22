//
//  FacebookService.swift
//  ChatApp
//
//  Created by BeeTech on 22/12/2022.
//

import Foundation
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import FirebaseAuth

class FacebookService {
    static let shared = FacebookService()
    
    func login(_ vc: LoginViewController, completed: @escaping (String, String, String) -> Void) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [], viewController: vc) { result in
            switch result {
            case .success(granted: _, declined: _, token: let token):
                let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email, name, picture"], tokenString: token.tokenString, version: nil, httpMethod: .get)
                request.start(completionHandler: { connection, result, err in
                    guard let result = result as? NSDictionary else { return }
                    guard let img = result["picture"] as? NSDictionary else { return }
                    guard let data = img["data"] as? NSDictionary else { return }
                    completed(result["name"] as! String, result["id"] as! String, data["url"] as! String)
                })
            default:
                break
            }
        }
    }
}
