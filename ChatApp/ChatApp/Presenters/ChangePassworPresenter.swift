//
//  ChangePassworPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 14/12/2022.
//

import Foundation

protocol ChangePasswordProtocol: AnyObject {
    func didGetChangePasswordResult(result: String?)
}

class ChangePasswordPresenter {
    // MARK: - Properties
    private weak var view: ChangePasswordProtocol?
    private var user: User?
    private var service = FirebaseService()
    
    // MARK: - Init
    init(view: ChangePasswordProtocol) {
        self.view = view
    }
    
    func setUser(_ user: User?) {
        self.user = user
    }
    
    func changePassword(_ currentPassword: String, _ newPassword: String, _ reEnterNewPassword: String) {
        guard let user = user else { return }
        if currentPassword.isEmpty {
            self.view?.didGetChangePasswordResult(result: Err.currentPasswordIsEmpty.rawValue)
        } else if currentPassword != user.password {
            self.view?.didGetChangePasswordResult(result: Err.passwordIncorrect.rawValue)
        } else if newPassword.isEmpty {
            self.view?.didGetChangePasswordResult(result: Err.newPasswordIsEmpty.rawValue)
        } else if reEnterNewPassword.isEmpty {
            self.view?.didGetChangePasswordResult(result: Err.reEnterNewPasswordIsEmpty.rawValue)
        } else if newPassword != reEnterNewPassword {
            self.view?.didGetChangePasswordResult(result: Err.passwordNotSame.rawValue)
        } else {
            self.service.changePassword(user.id, newPassword) {
                self.view?.didGetChangePasswordResult(result: nil)
            }
        }
    }
}
