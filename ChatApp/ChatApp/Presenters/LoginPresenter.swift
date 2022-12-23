//
//  LoginPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation

protocol LoginProtocol: AnyObject {
    func didGetLoginResult(result: Bool, senderId: String)
}

class LoginPresenter {
    
    // MARK: - Properties
    private weak var view: LoginProtocol?
    private var users = [User]()
    private var newUser: User?
    
    // MARK: - Init
    init(view: LoginProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - setter
    func getAllUser() -> [User] {
        return self.users
    }
    
    // MARK: - Data Handler Methods
    func fetchUser() {
        FirebaseService.shared.fetchUser { [weak self] users in
            self?.users = users
        }
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
        FacebookService.shared.login(vc) { [weak self] name, id, url in
            self?.register(name, id, url)
        }
    }
    
    func zaloLogin(_ vc: LoginViewController) {
        ZaloService.shared.login(vc) { [weak self] name, id, url in
            self?.register(name, id, url)
        }
    }
    
    func googleLogin(_ vc: LoginViewController) {
        GoogleService.shared.login(vc) { [weak self] name, id, url in
            self?.register(name, id, url)
        }
    }
    
    private func register(_ name: String, _ id: String, _ url: String) {
        if users.contains(where: { user in
            user.id == id
        }) {
            self.view?.didGetLoginResult(result: true, senderId: id)
        } else {
            FirebaseService.shared.register(name, id, "", url) { [weak self] in
                self?.view?.didGetLoginResult(result: true, senderId: id)
            }
        }
    }
}
