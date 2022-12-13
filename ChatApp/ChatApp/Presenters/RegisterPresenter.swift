//
//  RegisterPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 12/12/2022.
//

import Firebase

protocol RegisterProtocol: AnyObject {
    func didGetRegisterResult(result: String?)
}

class RegisterPresenter {
    
    // MARK: - Properties
    private weak var view: RegisterProtocol?
    private var db = Firestore.firestore()
    private var storage = Storage.storage().reference()
    private var users = [User]()
    private var imgUrl: String = ""
    private var name: String = ""
    private var username: String = ""
    private var password: String = ""
    private var service = FirebaseService()
    
    // MARK: - Init
    init(view: RegisterProtocol) {
        self.view = view
    }
    
    // MARK: Fetch user
    func fetchUser() {
        self.service.fetchUser { users in
            self.users = users
        }
    }
    
    // MARK: Get img url from firestore and save to property
    func setImgUrl(img: UIImage, completed: @escaping () -> Void) {
        self.service.fetchAvtUrl(img: img) { url in
            self.imgUrl = url
            completed()
        }
    }
    
    // MARK: check register and send data if check success
    func register(_ name: String,_ username: String,_ password: String) {
        self.users.forEach { user in
            if name.isEmpty {
                self.view?.didGetRegisterResult(result: Err.nameIsEmpty.rawValue)
            } else if username.isEmpty {
                self.view?.didGetRegisterResult(result: Err.usernameIsEmpty.rawValue)
            } else if password.isEmpty {
                self.view?.didGetRegisterResult(result: Err.passwordIsEmpty.rawValue)
            } else if self.imgUrl.isEmpty {
                self.view?.didGetRegisterResult(result: Err.imgIsEmpty.rawValue)
            } else if user.username == username {
                self.view?.didGetRegisterResult(result: Err.usernameExist.rawValue)
            } else {
                let docRef = self.db.collection("user").document("\(self.users.count + 1)")
                docRef.setData([
                    "id": self.users.count + 1,
                    "username": username,
                    "password": password,
                    "name": name,
                    "imgUrl": self.imgUrl
                ])
                self.view?.didGetRegisterResult(result: nil)
            }
        }
    }
}
