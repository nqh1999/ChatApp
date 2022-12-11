//
//  LoginPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation
import Firebase

protocol LoginProtocol: AnyObject {
    func didGetLoginResult(result: Bool, userId: Int)
}

class LoginPresenter {
    
    // MARK: - Properties
    private weak var view: LoginProtocol?
    private var db = Firestore.firestore()
    private var users = [User]()
    
    // MARK: - Init
    init(view: LoginProtocol) {
        self.view = view
    }
    
    // MARK: - Handler Methods
    func fetchUser() {
        self.db.collection("user").getDocuments() { querySnapshot, err in
            guard let querySnapshot = querySnapshot else { return }
            if err != nil { return }
            querySnapshot.documents.forEach { document in
                let user = document.data() as [String: Any]
                let value = User(user: user)
                self.users.append(value)
            }
        }
    }
    
    // check and send result, user id if login sucess to view
    func checkLogin(username: String, password: String) {
        var result: Bool = false
        var id: Int = 0
        self.users.forEach { user in
            if user.username == username && user.password == password {
                result = true
                id = user.id
            }
        }
        self.view?.didGetLoginResult(result: result, userId: id)
    }
}
