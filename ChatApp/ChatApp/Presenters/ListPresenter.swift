//
//  ListPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 08/12/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol ListProtocol: AnyObject {
    func dataObservable() -> Observable<[User]>
}

class ListPresenter {
    
    // MARK: - Properties
    private weak var view: ListProtocol?
    private var allUsers = BehaviorRelay<[User]>(value: [])
    private var receivers = BehaviorRelay<[User]>(value: [])
    private var sender = BehaviorRelay<[User]>(value: [])
    private var senderId: String = ""
    private var disposeBag = DisposeBag()
    private var message: Message?
    
    // MARK: - Init
    init(view: ListProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - Setter
    func setData(_ id: String) {
        self.senderId = id
    }
    
    func setState(_ sender: User, _ receiver: User) {
        FirebaseService.shared.setStateUnreadMessage(sender, receiver)
    }
    
//    func getReceiver() -> [User] {
//        if isTrue {
//            return self.receivers.value
//        } else {
//            return self.search.value
//        }
//    }
    
    func getSender() -> User? {
        FirebaseService.shared.fetchUser()
            .map({ users in
                users.filter { user in
                    user.id == self.senderId
                }
            })
            .bind(to: self.sender)
            .disposed(by: self.disposeBag)
        return self.sender.value.last
    }
    
    func getSenderId() -> String {
        return self.senderId
    }
    
    func getMessage() -> Message? {
        return self.message
    }
    
    // MARK: - Data Handler Methods
    func fetchData() {
        FirebaseService.shared.fetchUser()
            .map({ users in
                users.filter { user in
                    user.id != self.senderId
                }
            })
            .bind(to: self.receivers)
            .disposed(by: self.disposeBag)
    }
    
    func fetchMessageById(_ id: String?) -> Observable<Message?> {
        guard let id = id else { return Observable.never()}
        FirebaseService.shared.fetchMessageById(id)
        return FirebaseService.shared.message
    }
    
    func dataObservable() -> Observable<[User]> {
        return self.receivers.asObservable()
    }
}
