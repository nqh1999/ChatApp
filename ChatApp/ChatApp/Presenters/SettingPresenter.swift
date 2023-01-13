//
//  SettingPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 14/12/2022.
//

import UIKit
import RxSwift
import RxRelay

protocol SettingProtocol: AnyObject {
    func didGetFetchUserResult(_ user: User?)
    func didGetSetImgResult(_ img: UIImage)
}

class SettingPresenter {
    
    // MARK: - Properties
    private weak var view: SettingProtocol?
    private var user: User?
    private var imgUrl: String = ""
    private var userId: String = ""
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(view: SettingProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - Setter
    func setUserId(_ id: String) {
        self.userId = id
    }
    
    func getUser() -> User? {
        return self.user
    }
    
    // MARK: - Data Handler Methods
    func fetchUser() {
        FirebaseService.shared.fetchUser { [weak self] users in
            guard let userId = self?.userId else { return }
            self?.user = users.filter{ user in
                user.id == userId
            }.first
            self?.view?.didGetFetchUserResult(self?.user)
        }
    }
    
    func setState() {
        FirebaseService.shared.setStateIsActive(userId, false)
        FacebookService.shared.logout()
        GoogleService.shared.logout()
        ZaloService.shared.logout()
    }
    
    func setImgUrl(_ img: UIImage) {
        FirebaseService.shared.changeAvt(self.userId, img).subscribe(onNext: { [weak self] in
            self?.view?.didGetSetImgResult(img)
        })
        .disposed(by: self.disposeBag)
    }
    
    func changeName(_ name: String) {
        FirebaseService.shared.changeName(self.userId, name)
    }
}

