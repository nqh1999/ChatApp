//
//  LoginPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol LoginProtocol: AnyObject {
    func didGetLoginResult(result: Bool, senderId: String)
}

class LoginPresenter {
    
    // MARK: - Properties
    private weak var view: LoginProtocol?
    private var users = BehaviorRelay<[User]>(value: [])
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(view: LoginProtocol) {
        self.view = view
    }
    
    // MARK: - Data Handler Methods
    func fetchUser() {
        FirebaseService.shared.fetchUser() { [weak self] users in
            self?.users.accept(users)
        }
    }
    
    func setState(_ id: String) {
        FirebaseService.shared.setStateIsActive(id, true)
    }
    
    func checkLogin(_ username: String, _ password: String) {
        self.users
            .subscribe { users in
                ValidateService.shared.checkLogin(users, username, password) { [weak self] result, senderId in
                    self?.view?.didGetLoginResult(result: result, senderId: senderId)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func facebookLogin(_ vc: LoginViewController) {
        FacebookService.shared.login(vc)
            .subscribe(onNext: { [weak self] name, id, url in
                self?.register(name, id, url)
            })
            .disposed(by: disposeBag)
    }
    
    func zaloLogin(_ vc: LoginViewController) {
        ZaloService.shared.login(vc)
            .subscribe(onNext: { [weak self] name, id, url in
                self?.register(name, id, url)
            })
            .disposed(by: disposeBag)
    }
    
    func googleLogin(_ vc: LoginViewController) {
        GoogleService.shared.login(vc)
            .subscribe(onNext: { [weak self] name, id, url in
                self?.register(name, id, url)
            })
            .disposed(by: disposeBag)
    }
    
    private func register(_ name: String, _ id: String, _ url: String) {
        self.users
            .subscribe { [weak self] users in
                if users.contains(where: { user in
                    user.id == id
                }) {
                    self?.view?.didGetLoginResult(result: true, senderId: id)
                    return
                }
                FirebaseService.shared.register(name, id, "", url) { [weak self] in
                    self?.view?.didGetLoginResult(result: true, senderId: id)
                }
            }
            .disposed(by: disposeBag)
    }
}
