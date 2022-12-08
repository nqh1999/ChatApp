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
            if err != nil {
                print(err!.localizedDescription)
            } else {
                guard let querySnapshot = querySnapshot else { return }
                querySnapshot.documents.forEach { document in
                    let user = document.data() as [String: Any]
                    let value = User(user: user)
                    self.users.append(value)
                }
            }
        }
    }
    func checkLogin(username: String, password: String) {
        var result: Bool = false
        var id: Int = 0
        users.forEach { user in
            if user.username == username && user.password == password {
                result = true
                id = user.id
            }
        }
        self.view?.didGetLoginResult(result: result, userId: id)
    }
}
