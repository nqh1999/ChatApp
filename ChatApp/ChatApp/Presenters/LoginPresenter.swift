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
    private weak var view: LoginProtocol?
    private var db = Firestore.firestore()
    private var users = [User]()
    
    init(view: LoginProtocol) {
        self.view = view
    }
    
    func fetchUser() {
        db.collection("user").getDocuments() { querySnapshot, err in
            if err != nil {
                print(err!.localizedDescription)
            } else {
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {
                    let dict = document.data() as [String: Any]
                    let value = User(dict: dict)
                    self.users.append(value)
                }
            }
        }
    }
    
    func checkLogin(username: String, password: String) {
        var isTrue = false
        var id: Int = 0
        users.forEach { user in
            if user.username == username && user.password == password {
                isTrue = true
                id = user.id
            }
        }
        view?.didGetLoginResult(result: isTrue, userId: id)
    }
}
