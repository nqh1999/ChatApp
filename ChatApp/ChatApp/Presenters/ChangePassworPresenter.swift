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
    private var validateService = ValidateService()
    
    // MARK: - Init
    init(view: ChangePasswordProtocol) {
        self.view = view
    }
    
    func setUser(_ user: User?) {
        self.user = user
    }
    
    func changePassword(_ currentPassword: String, _ newPassword: String, _ reEnterNewPassword: String) {
        guard let user = user else { return }
        self.validateService.checkChangePasswordData(user, currentPassword, newPassword, reEnterNewPassword) { result in
            if let result = result {
                self.view?.didGetChangePasswordResult(result: result)
            } else {
                self.service.changePassword(user.id, newPassword) {
                    self.view?.didGetChangePasswordResult(result: nil)
                }
            }
        }
    }
}
