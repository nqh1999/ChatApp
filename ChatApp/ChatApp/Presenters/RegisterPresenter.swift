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
    // MARK: - Init
    init(view: RegisterProtocol) {
        self.view = view
    }
    
    // MARK: - Data Handler Methods
    func fetchUser() {
        FirebaseService.shared.fetchUser { [weak self] users in
            self?.users = users
        }
    }
    
    func setImgUrl(_ img: UIImage, completed: @escaping () -> Void) {
        FirebaseService.shared.fetchAvtUrl(img: img) { [weak self] url in
            self?.imgUrl = url
            completed()
        }
    }
    
    func register(_ name: String,_ username: String,_ password: String) {
        ValidateService.shared.checkRegisterData(self.users, name, username, password, self.imgUrl) { [weak self] result in
            if let result = result {
                self?.view?.didGetRegisterResult(result: result)
            } else {
                guard let url = self?.imgUrl else { return }
                FirebaseService.shared.register(name, username, password, url) { [weak self] in
                    self?.view?.didGetRegisterResult(result: nil)
                }
            }
        }
    }
}
