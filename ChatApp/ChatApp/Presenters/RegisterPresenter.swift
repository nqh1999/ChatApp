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
    private var users = [User]()
    private var imgUrl: String = ""
    private var disposeBag = DisposeBag()
    
    // MARK: - Init
    init(view: RegisterProtocol) {
        self.view = view
    }
    
    // MARK: - Data Handler Methods
    func fetchUser() {
        Service.shared.fetchUsers()
            .subscribe(onNext: { users in
                self.users = users
            })
            .disposed(by: disposeBag)
    }
    
    func setImgUrl(_ img: UIImage) {
        Service.shared.fetchAvtUrl(img: img)
            .subscribe(onNext: { [weak self] url in
                self?.imgUrl = url
                self?.view?.didGetSetImageResult(img)
            })
            .disposed(by: disposeBag)
    }
    
    func register(_ name: String,_ username: String,_ password: String) {
        ValidateService.shared.checkRegisterData(self.users, name, username, password, self.imgUrl) { [weak self] result in
            if let result = result {
                self?.view?.didGetRegisterResult(result: result)
            } else {
                guard let url = self?.imgUrl else { return }
                Service.shared.register(name, username, password, url)
                    .subscribe(onCompleted: {
                        self?.view?.didGetRegisterResult(result: nil)
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
}
