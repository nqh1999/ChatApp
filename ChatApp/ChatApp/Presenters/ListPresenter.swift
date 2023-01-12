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
    
    private let receivers = BehaviorRelay<[User]>(value: [])
    private var searchData = BehaviorRelay<[User]>(value: [])
    private let sender = BehaviorRelay<User?>(value: nil)
    private let userMessage = BehaviorRelay<[(User,Message?)]>(value: [])
    private var searchText = PublishSubject<String>()
    private var senderId: String = ""
    
    private let disposeBag = DisposeBag()
    
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
        
        self.receivers.subscribe(onNext: { [weak self] users in
            self?.searchData.accept(users)
        })
        .disposed(by: self.disposeBag)
        
        FirebaseService.shared.fetchUser() { [weak self] users in
            let tmp = users.filter { user in
                user.id == self?.senderId
            }.first
            self?.sender.accept(tmp)
        }
        self.dataHandler()
    }
    
    // MARK: Handler Data
    private func dataHandler() {
        self.receivers.subscribe(onNext: { [weak self] receivers in
            var arr = [(User,Message?)]()
            guard let senderId = self?.senderId else { return }
            receivers.forEach { receiver in
                if let id = receiver.lastMessages[senderId] {
                    FirebaseService.shared.fetchMessageById(id) { [weak self] message in
                        guard let message = message else { return }
                        for (index, value) in arr.enumerated() {
                            if value.1?.messageId == message.messageId {
                                arr.remove(at: index)
                            }
                        }
                        if (message.senderId == senderId && message.senderDeleted) || (message.receiverId == senderId && message.receiverDeleted) || (message.senderDeleted && message.receiverDeleted) {
                            arr.append((receiver,nil))
                        } else {
                            arr.insert((receiver,message), at: 0)
                        }
                        self?.userMessage.accept(arr)
                    }
                } else {
                    arr.append((receiver,nil))
                    self?.userMessage.accept(arr)
                    return
                }
            }
        })
        .disposed(by: self.disposeBag)
        
        self.view?.didFetchData(self.userMessage)
    }
    
    func searchUserWithText(_ text: String?) {
        let text = text ?? ""
        self.searchText.onNext(text)
        
        self.searchText.subscribe(onNext: { [weak self] text in
            if text.isEmpty {
                self?.searchData.accept(self?.receivers.value ?? [])
            } else {
                let arr = self?.receivers.value.filter { user in
                    user.name.lowercased().contains(text.lowercased())
                }
                self?.searchData.accept(arr ?? [])
            }
        })
        .disposed(by: self.disposeBag)
    }
    
    // MARK: Check deleted or not
    private func checkMessage(_ message: Message?) {
        
    }
}
