//
//  RegisterPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 12/12/2022.
//

import UIKit

protocol RegisterProtocol: AnyObject {
    func didGetRegisterResult(result: String?)
}

class RegisterPresenter {
    
    // MARK: - Properties
    private weak var view: RegisterProtocol?
    private var users = [User]()
    private var imgUrl: String = ""
    private var service = FirebaseService()
    private var validateService = ValidateService()
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
        self.validateService.checkRegisterData(self.users, name, username, password, self.imgUrl) { result in
            if let result = result {
                self.view?.didGetRegisterResult(result: result)
            } else {
                self.service.register(self.users.count + 1, name, username, password, self.imgUrl) {
                    self.view?.didGetRegisterResult(result: nil)
                }
            }
        }
    }
}
