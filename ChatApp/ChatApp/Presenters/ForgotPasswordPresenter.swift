//
//  ForgotPasswordPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 15/12/2022.
//

import Foundation

protocol ForgotPasswordProtocol: AnyObject {
    func didGetValidateUsernameResult(result: String?, newPass: String)
}

class ForgotPasswordPresenter {
    
    // MARK: - Properties
    private weak var view: ForgotPasswordProtocol?
    private var service = FirebaseService()
    private var validateService = ValidateService()
    private var users = [User]()
    private var newPass: String = ""
    
    // MARK: - Init
    init(view: ForgotPasswordProtocol) {
        self.view = view
    }
    
    // MARK: - Data Handler Methods
    func fetchUser() {
        self.service.fetchUser { [weak self] users in
            self?.users = users
        }
    }
    
    func checkUsername(_ username: String) {
        self.validateService.checkUsername(self.users, username) { [weak self] result, id in
            if let result = result {
                self?.view?.didGetValidateUsernameResult(result: result, newPass: "")
            } else {
                guard let newPass = self?.randomNameString() else { return }
                self?.service.changePassword(id, newPass) {
                    self?.view?.didGetValidateUsernameResult(result: nil, newPass: newPass)
                }
            }
        }
    }
    
    private func randomNameString() -> String {
        let c = Array("abcdefghjklmnpqrstuvwxyz12345789")
        let k = UInt32(c.count)
        var result = [Character](repeating: "-", count: 6)
        for i in 0..<6 {
            let r = Int(arc4random_uniform(k))
            result[i] = c[r]
        }
        return String(result)
    }
}

