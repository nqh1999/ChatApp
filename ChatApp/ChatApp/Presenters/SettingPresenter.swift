//
//  SettingPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 14/12/2022.
//

import UIKit

protocol SettingProtocol: AnyObject {
    
}

class SettingPresenter {
    
    // MARK: - Properties
    private weak var view: SettingProtocol?
    private var user: User?
    private var imgUrl: String = ""
    private var service = FirebaseService()
    private var userId: Int = 0
    
    // MARK: - Init
    init(view: SettingProtocol) {
        self.view = view
    }
    
    func setUserId(_ id: Int) {
        self.userId = id
    }
    
    func getUser() -> User? {
        return self.user
    }
    
    // MARK: Fetch user
    func fetchUser(completed: @escaping (User?) -> Void) {
        self.service.fetchUser { users in
            users.forEach { user in
                if user.id == self.userId {
                    self.user = user
                }
            }
            completed(self.user)
        }
    }
    
    // MARK: Get img url from firestore and save to property
    func setImgUrl(_ img: UIImage, completed: @escaping () -> Void) {
        self.service.changeAvt(self.userId, img) {
            completed()
        }
    }
    
    func changeName(_ name: String, completed: @escaping () -> Void) {
        self.service.changeName(self.userId, name) {
            completed()
        }
    }
}

