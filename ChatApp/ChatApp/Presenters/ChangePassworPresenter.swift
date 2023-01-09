//
//  ChangePassworPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 14/12/2022.
//

import Foundation
import RxSwift

protocol ChangePasswordProtocol: AnyObject {
    func didGetChangePasswordResult(result: String?)
}

class ChangePasswordPresenter {
    // MARK: - Properties
    private weak var view: ChangePasswordProtocol?
    private var user: User?
    private var disposeBag = DisposeBag()
    
    // MARK: - Init
    init(view: ChangePasswordProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - Setter
    func setUser(_ user: User?) {
        self.user = user
    }
    
    // MARK: - Data Handler Methods
    func handlerData(_ currentPassword: String, _ newPassword: String, _ reEnterNewPassword: String) {
        guard let user = user else { return }
        ValidateService.shared.checkChangePasswordData(user, currentPassword, newPassword, reEnterNewPassword) { [weak self] result in
            if let result = result {
                self?.view?.didGetChangePasswordResult(result: result)
            } else {
                FirebaseService.shared.changePassword(user.id, newPassword) { [weak self] in
                    self?.view?.didGetChangePasswordResult(result: nil)
                }
            }
        }
    }
}
