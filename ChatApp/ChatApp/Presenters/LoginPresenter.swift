//
//  LoginPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation
import Firebase

protocol LoginProtocol: AnyObject {
    func didGetLoginResult(result: Bool, senderId: Int)
}

class LoginPresenter {
    
    // MARK: - Properties
    private weak var view: LoginProtocol?
    private var db = Firestore.firestore()
    private var users = [User]()
    private var senderId: Int = 0
    private var service = FirebaseService()
    
    // MARK: - Init
    init(view: LoginProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - setter
    func getAllUser() -> [User] {
        return self.users
    }
    
    // MARK: - Handler Methods
    func fetchUser() {
        self.service.fetchUser { users in
            self.users = users
        }
    }
    
    // check and send result, user id if login sucess to view
    func checkLogin(username: String, password: String) {
        var result: Bool = false
        self.users.forEach { user in
            if user.username == username && user.password == password {
                result = true
                self.senderId = user.id
            }
        }
        self.view?.didGetLoginResult(result: result, senderId: self.senderId)
    }
}
