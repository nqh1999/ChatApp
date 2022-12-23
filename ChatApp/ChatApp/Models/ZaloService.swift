//
//  ZaloServices.swift
//  ChatApp
//
//  Created by BeeTech on 22/12/2022.
//

import Foundation
import ZaloSDK

class ZaloService {
    
    // MARK: - Properties
    static let shared = ZaloService()
    private var codeChallenage = ""
    private var codeVerifier = ""
    
    func login(_ vc: LoginViewController, completed: @escaping (String, String, String) -> Void) {
        self.codeVerifier = generateCodeVerifier() ?? ""
        self.codeChallenage = generateCodeChallenge(codeVerifier: self.codeVerifier) ?? ""
        ZaloSDK.sharedInstance().authenticateZalo(with: ZAZaloSDKAuthenTypeViaWebViewOnly, parentController: vc, codeChallenge: self.codeChallenage, extInfo: Constant.EXT_INFO) { [weak self] response in
            
            self?.onAuthenticateComplete(with: response) { name, id, url in
                completed(name, id, url)
            }
        }
    }
    
    func logout() {
        ZaloSDK.sharedInstance().unauthenticate()
    }
    
    private func onAuthenticateComplete(with response: ZOOauthResponseObject?, completed: @escaping (String, String, String) -> Void) {
        guard let response = response, response.errorCode != -1001 else { return }
        if response.isSucess {
            ZaloSDK.sharedInstance().getAccessToken(withOAuthCode: response.oauthCode, codeVerifier: self.codeVerifier) { tokenResponse in
                guard let accessToken = tokenResponse?.accessToken else { return }
                ZaloSDK.sharedInstance().getZaloUserProfile(withAccessToken: accessToken) { profile in
                    guard let profile = profile,
                        profile.isSucess,
                        let name = profile.data["name"] as? String,
                        let id = profile.data["id"] as? String,
                        let picture = profile.data["picture"] as? [String: Any?],
                        let pictureData = picture["data"] as? [String: Any?],
                        let url = pictureData["url"] as? String
                        else {
                        return
                    }
                    completed(name, id, url)
                }
            }
        } else {
            return
        }
    }
}
