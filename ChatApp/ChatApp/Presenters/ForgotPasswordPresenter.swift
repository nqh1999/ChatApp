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
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(view: ForgotPasswordProtocol) {
        self.view = view
    }
    
    // MARK: - Data Handler Methods
    func fetchUser() {
        FirebaseService.shared.fetchUser() { [weak self] users in
            self?.users = users
        }
    }
    
    func checkUsername(_ username: String) {
        ValidateService.shared.checkUsername(self.users, username) { [weak self] result, id in
            if let result = result {
                self?.view?.didGetValidateUsernameResult(result: result, newPass: "")
            } else {
                let newPass = randomNameString()
                FirebaseService.shared.changePassword(id, newPass).subscribe(onCompleted: { [weak self] in
                    self?.view?.didGetValidateUsernameResult(result: nil, newPass: newPass)
                })
                .disposed(by: self!.disposeBag)
            }
        }
    }
}

