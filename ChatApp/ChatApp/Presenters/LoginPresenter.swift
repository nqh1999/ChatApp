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
    private let users = BehaviorRelay<[User]>(value: [])
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(view: LoginProtocol) {
        self.view = view
    }
    
    // MARK: Fetch User
    func fetchUser() {
        FirebaseService.shared.fetchUser() { [weak self] users in
            self?.users.accept(users)
        }
    }
    
    // MARK: Set State
    func setState(_ id: String) {
        FirebaseService.shared.setStateIsActive(id, true)
    }
    
    // MARK: Check Login
    func checkLogin(_ username: String?, _ password: String) {
        let username = username ?? ""
        ValidateService.shared.checkLogin(users.value, username, password) { [weak self] result, senderId in
            self?.view?.didGetLoginResult(result: result, senderId: senderId)
        }
    }
    
    // MARK: Facebook login
    func facebookLogin(_ vc: LoginViewController) {
        FacebookService.shared.login(vc).subscribe(onNext: { [weak self] name, id, url in
            self?.register(name, id, url)
        })
        .disposed(by: self.disposeBag)
    }
    
    // MARK: Zalo login
    func zaloLogin(_ vc: LoginViewController) {
        ZaloService.shared.login(vc).subscribe(onNext: { [weak self] name, id, url in
            self?.register(name, id, url)
        })
        .disposed(by: self.disposeBag)
    }
    
    // MARK: Google login
    func googleLogin(_ vc: LoginViewController) {
        GoogleService.shared.login(vc).subscribe(onNext: { [weak self] name, id, url in
            self?.register(name, id, url)
        })
        .disposed(by: self.disposeBag)
    }
    
    // MARK: Register
    private func register(_ name: String, _ id: String, _ url: String) {
        self.users.subscribe(onNext: { [weak self] users in
            if users.contains(where: { user in
                user.id == id
            }) {
                self?.view?.didGetLoginResult(result: true, senderId: id)
                return
            }
            FirebaseService.shared.register(name, id, "", url).subscribe(onCompleted: { [weak self] in
                self?.view?.didGetLoginResult(result: true, senderId: id)
            })
            .disposed(by: self!.disposeBag)
        })
        .disposed(by: self.disposeBag)
    }
}
