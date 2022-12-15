//
//  LoginPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation

protocol LoginProtocol: AnyObject {
    func didGetLoginResult(result: Bool, senderId: Int)
}

class LoginPresenter {
    
    // MARK: - Properties
    private weak var view: LoginProtocol?
    private var users = [User]()
    private var service = FirebaseService()
    private var validateService = ValidateService()
    
    // MARK: - Init
    init(view: LoginProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - setter
    func getAllUser() -> [User] {
        return self.users
    }
    
    // MARK: fetch user
    func fetchUser() {
        self.service.fetchUser { users in
            self.users = users
        }
    }
    
    // MARK: check and send (result, senderid) to view if login sucess
    func checkLogin(username: String, password: String) {
        self.validateService.checkLogin(users, username, password) { result, senderId in
            self.view?.didGetLoginResult(result: result, senderId: senderId)
        }
    }
}
