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
    var codeChallenage = ""
    var codeVerifier = ""
    
    func login(_ vc: LoginViewController, completed: @escaping (String, String, String) -> Void) {
        self.codeVerifier = generateCodeVerifier() ?? ""
        self.codeChallenage = generateCodeChallenge(codeVerifier: self.codeVerifier) ?? ""
        ZaloSDK.sharedInstance().authenticateZalo(with: ZAZAloSDKAuthenTypeViaZaloAppAndWebView, parentController: vc, codeChallenge: self.codeChallenage, extInfo: Constant.EXT_INFO) { (response) in
            self.onAuthenticateComplete(with: response) { name, id, url in
                completed(name, id, url)
            }
        }
    }
    
    private func onAuthenticateComplete(with response: ZOOauthResponseObject?, completed: @escaping (String, String, String) -> Void) {
        guard let response = response, response.errorCode != -1001 else { return }
        if response.isSucess {
            self.getProfile(response.oauthCode) { name, id, url in
                completed(name, id, url)
            }
        }
    }

    private func getProfile(_ oauthCode: String?, completed: @escaping (String, String, String) -> Void) {
        ZaloSDK.sharedInstance().getAccessToken(withOAuthCode: oauthCode, codeVerifier: self.codeVerifier) { (tokenResponse) in
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
    }
}
