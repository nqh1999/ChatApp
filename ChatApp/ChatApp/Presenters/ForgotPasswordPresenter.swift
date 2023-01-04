//
//  ForgotPasswordPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 15/12/2022.
//

import Foundation
import RxSwift

protocol ForgotPasswordProtocol: AnyObject {
    func didGetValidateUsernameResult(result: String?, newPass: String)
}

class ForgotPasswordPresenter {
    
    // MARK: - Properties
    private weak var view: ForgotPasswordProtocol?
    private var users = [User]()
    private var newPass: String = ""
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(view: ForgotPasswordProtocol) {
        self.view = view
    }
    
    // MARK: - Data Handler Methods
    func fetchUser() {
        func fetchUser() {
            Service.shared.fetchUsers()
                .subscribe(onNext: { [weak self] users in
                    self?.users = users
                })
                .disposed(by: disposeBag)
        }
    }
    
    func checkUsername(_ username: String) {
        ValidateService.shared.checkUsername(self.users, username) { [weak self] result, id in
            if let result = result {
                self?.view?.didGetValidateUsernameResult(result: result, newPass: "")
            } else {
                let newPass = randomNameString()
                Service.shared.changePassword(id, newPass)
                    .subscribe(onCompleted: { [weak self] in
                        self?.view?.didGetValidateUsernameResult(result: nil, newPass: newPass)
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
}

