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
    func didFetchData(_ observable: BehaviorRelay<[(User,Message?)]>)
}

class ListPresenter {
    
    // MARK: - Properties
    private weak var view: ListProtocol?
    
    private var receivers = BehaviorRelay<[User]>(value: [])
    private var sender = BehaviorRelay<User?>(value: nil)
    private var userMessage = BehaviorRelay<[(User,Message?)]>(value: [])
    private var senderId: String = ""
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Init
    init(view: ListProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - Setter
    func setData(_ id: String) {
        self.senderId = id
    }
    
    func setState(_ sender: User, _ receiver: User, _ message: Message?) {
        guard let message = message else { return }
        if message.receiverId == self.senderId {
            FirebaseService.shared.setStateUnreadMessage(sender, receiver)
        }
    }
    
    func getSender() -> User? {
        return self.sender.value
    }
    
    // MARK: Fetch Data
    func fetchData() {
        FirebaseService.shared.fetchUser() { [weak self] users in
            let tmp = users.filter { user in
                user.id != self?.senderId
            }
            self?.receivers.accept(tmp)
        }
        
        FirebaseService.shared.fetchUser() { [weak self] users in
            let tmp = users.filter { user in
                    user.id == self?.senderId
            }.first
            self?.sender.accept(tmp)
        }
        self.dataHandler()
    }
    
    // MARK: Hanler Data
    private func dataHandler() {
        self.receivers.subscribe(onNext: { [weak self] users in
            var arr = [(User,Message?)]()
            guard let senderId = self?.senderId else { return }
            users.forEach { user in
                if let id = user.lastMessages[senderId] {
                    FirebaseService.shared.fetchMessageById(id) { [weak self] message in
                        for (index, value) in arr.enumerated() {
                            if value.0 == user {
                                arr.remove(at: index)
                                arr.insert((user,message), at: 0)
                                self?.userMessage.accept(arr)
                                return
                            } else {
                                arr.insert((user,message), at: 0)
                                self?.userMessage.accept(arr)
                                return
                            }
                        }
                    }
                } else {
//                    if arr.contains(where: { value in
//                        value.0 == user
//                    }) {
//                        return
//                    } else {
                        arr.append((user,nil))
                        self?.userMessage.accept(arr)
                        return
//                    }
                }
            }
        }).disposed(by: self.disposeBag)
        
        self.view?.didFetchData(self.userMessage)
    }
}
