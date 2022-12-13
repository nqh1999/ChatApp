//
//  LoginPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

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
    
    // MARK: fetch user
    func fetchUser() {
        self.service.fetchUser { users in
            self.users = users
        }
    }
    
    // MARK: check and send (result, senderid) to view if login sucess
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
