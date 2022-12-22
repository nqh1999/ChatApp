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
    private var service = FirebaseService()
    private var validateService = ValidateService()
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
        self.service.fetchUser { [weak self] users in
            self?.users = users
        }
    }
    
    func setState(_ id: String) {
        self.service.setStateIsActive(id, true)
    }
    
    func checkLogin(_ username: String, _ password: String) {
        self.validateService.checkLogin(users, username, password) { [weak self] result, senderId in
            self?.view?.didGetLoginResult(result: result, senderId: senderId)
        }
    }
    
    func facebookLogin(_ name: String,_ username: String, _ imgUrl: String) {
        self.service.register(name, username,"", imgUrl) { [weak self] in
            self?.view?.didGetLoginResult(result: true, senderId: username)
        }
    }
}
