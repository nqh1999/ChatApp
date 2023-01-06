//
//  RegisterPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 12/12/2022.
//

import UIKit
import RxSwift
import RxRelay

protocol RegisterProtocol: AnyObject {
    func didGetRegisterResult(result: String?)
    func didGetSetImageResult(_ img: UIImage)
}

class RegisterPresenter {
    
    // MARK: - Properties
    private weak var view: RegisterProtocol?
    private var users = BehaviorRelay<[User]>(value: [])
    private var imgUrl: String = ""
    private var disposeBag = DisposeBag()
    
    // MARK: - Init
    init(view: RegisterProtocol) {
        self.view = view
    }
    
    // MARK: - Data Handler Methods
    func fetchUser() {
        FirebaseService.shared.fetchUser()
            .bind(to: self.users)
            .disposed(by: self.disposeBag)
    }
    
    func setImgUrl(_ img: UIImage) {
        FirebaseService.shared.fetchAvtUrl(img: img)
            .subscribe(onNext: { [weak self] url in
                self?.imgUrl = url
                self?.view?.didGetSetImageResult(img)
            })
            .disposed(by: self.disposeBag)
    }
    
    func register(_ name: String,_ username: String,_ password: String) {
        self.users
            .subscribe { [weak self] users in
                guard let url = self?.imgUrl, let bag = self?.disposeBag else { return }
                ValidateService.shared.checkRegisterData(users, name, username, password, url) { [weak self] result in
                    if let result = result {
                        self?.view?.didGetRegisterResult(result: result)
                    } else {
                        FirebaseService.shared.register(name, username, password, url)
                            .subscribe(onCompleted: { [weak self] in
                                self?.view?.didGetRegisterResult(result: nil)
                            })
                            .disposed(by: bag)
                    }
                }
            }
            .disposed(by: self.disposeBag)
    }
}
