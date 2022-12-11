//
//  LoginPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation
import Firebase

protocol LoginProtocol: AnyObject {
    func didGetLoginResult(result: Bool, sender: User?, receivers: [User])
}

class LoginPresenter {
    
    // MARK: - Properties
    private weak var view: LoginProtocol?
    private var db = Firestore.firestore()
    private var users = [User]()
    private var receivers = [User]()
    private var sender: User?
    
    // MARK: - Init
    init(view: LoginProtocol) {
        self.view = view
    }
    
    // MARK: - Handler Methods
    func fetchUser() {
        self.db.collection("user").addSnapshotListener { querySnapshot, err in
            guard let querySnapshot = querySnapshot, err == nil else { return }
            querySnapshot.documents.forEach { document in
                let user = User(user: document.data())
                self.users.append(user)
            }
        }
    }
    
    func setupData(senderId: Int) {
        users.forEach { user in
            if user.id == senderId {
                self.sender = user
            } else {
                receivers.append(user)
            }
        }
    }
    
    // check and send result, user id if login sucess to view
    func checkLogin(username: String, password: String) {
        var result: Bool = false
        self.users.forEach { user in
            if user.username == username && user.password == password {
                result = true
                self.setupData(senderId: user.id)
            }
        }
        self.view?.didGetLoginResult(result: result, sender: self.sender, receivers: self.receivers)
    }
}
