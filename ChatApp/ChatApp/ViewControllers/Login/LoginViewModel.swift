//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Nguyen Quang Huy on 12/06/2023.
//

import Foundation
import RxSwift
import RxRelay

class LoginViewModel: BaseViewModel {
    // MARK: - Properties
    let users = BehaviorRelay<[User]>(value: [])
    let isLoginSuccess = BehaviorRelay<Bool>(value: false)
    // MARK: Fetch User
    func fetchUser() {
        FirebaseService.shared.fetchUser { [weak self] users in
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
            self?.isLoginSuccess.accept(result)
            guard result else { return }
            SharedData.shared.setUserId(id: senderId)
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
    func googleLogin(_ vc: LoginViewController) -> Observable<(String,String,String)> {
        return GoogleService.shared.login(vc)
    }
    
    // MARK: Register
    func register(_ name: String, _ id: String, _ url: String) {
        self.users.subscribe(onNext: { [weak self] users in
            if users.contains(where: { user in
                user.id == id
            }) {
                self?.isLoginSuccess.accept(true)
                SharedData.shared.setUserId(id: id)
                return
            }
            FirebaseService.shared.register(name, id, "", url).subscribe(onCompleted: { [weak self] in
                self?.isLoginSuccess.accept(true)
                SharedData.shared.setUserId(id: id)
            })
            .disposed(by: self!.disposeBag)
        })
        .disposed(by: self.disposeBag)
    }
}
