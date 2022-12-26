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
    
    func login(_ vc: LoginViewController, completed: @escaping (String, String, String) -> Void) {
        var codeVerifier = generateCodeVerifier() ?? ""
        var codeChallenage = generateCodeChallenge(codeVerifier: codeVerifier) ?? ""
        ZaloSDK.sharedInstance().authenticateZalo(with: ZAZaloSDKAuthenTypeViaWebViewOnly, parentController: vc, codeChallenge: codeChallenage, extInfo: Constant.EXT_INFO) { response in
            guard let response = response, response.errorCode != -1001 else { return }
            if response.isSucess {
                ZaloSDK.sharedInstance().getAccessToken(withOAuthCode: response.oauthCode, codeVerifier: codeVerifier) { tokenResponse in
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
    }
    
    func logout() {
        ZaloSDK.sharedInstance().unauthenticate()
    }
}
