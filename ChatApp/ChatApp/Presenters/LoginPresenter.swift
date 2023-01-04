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
    private let userArr = BehaviorRelay<[User]>(value: [])
    private var users = [User]()
    private var newUser: User?
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Init
    init(view: LoginProtocol) {
        self.view = view
    }
    
    // MARK: - Data Handler Methods
    func fetchUser() {
        Service.shared.fetchUsers()
            .bind(to: self.userArr)
            .disposed(by: disposeBag)
        
        self.userArr.subscribe(onNext: { users in
            self.users = users
        }).disposed(by: disposeBag)
    }
    
    func setState(_ id: String) {
        FirebaseService.shared.setStateIsActive(id, true)
    }
    
    func checkLogin(_ username: String, _ password: String) {
        ValidateService.shared.checkLogin(users, username, password) { [weak self] result, senderId in
            self?.view?.didGetLoginResult(result: result, senderId: senderId)
        }
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
        if users.contains(where: { user in
            user.id == id
        }) {
            self.view?.didGetLoginResult(result: true, senderId: id)
            return
        }
        
        Service.shared.register(name, id, "", url)
            .subscribe(onCompleted: {
                self.view?.didGetLoginResult(result: true, senderId: id)
            })
            .disposed(by: disposeBag)
    }
}
