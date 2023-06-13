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
    let users = BehaviorRelay<[User]>(value: [])
    let isLoginSuccess = BehaviorRelay<Bool>(value: false)
    
    func fetchUser() {
        FirebaseService.shared.fetchUser { [weak self] users in
            self?.users.accept(users)
        }
    }
    
    func setState() {
        FirebaseService.shared.setStateIsActive(SharedData.shared.getUserId(), true)
    }
    
    func checkLogin(_ username: String?, _ password: String) {
        let username = username ?? ""
        ValidateService.shared.checkLogin(users.value, username, password) { [weak self] result, senderId in
            self?.isLoginSuccess.accept(result)
            guard result else { return }
            SharedData.shared.setUserId(id: senderId)
        }
    }
    
    func socialRegister(_ name: String, _ id: String, _ url: String) {
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
            }).disposed(by: self!.disposeBag)
        }).disposed(by: self.disposeBag)
    }
}
