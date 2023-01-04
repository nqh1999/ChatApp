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
    func didFetchData(_ receiver: PublishRelay<[User]>, _ message: PublishRelay<[String: Message]>)
}

class ListPresenter {
    
    // MARK: - Properties
    private weak var view: ListProtocol?
    private var allUsers = PublishRelay<[User]>()
    private var receivers = PublishRelay<[User]>()
    private var sender = PublishRelay<[User]>()
    private var allMessage = PublishRelay<[Message]>()
    private var message = PublishRelay<[String: Message]>()
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
    
    func setState(_ sender: User, _ receiver: User) {
        FirebaseService.shared.setStateUnreadMessage(sender, receiver)
    }
    
    // MARK: - Data Handler Methods
    func fetchData() {
        Service.shared.fetchUsers()
            .bind(to: self.allUsers)
            .disposed(by: self.disposeBag)
        
        Service.shared.fetchMessage()
            .bind(to: self.allMessage)
            .disposed(by: disposeBag)
        
        self.allUsers
            .map({ users in
                users.filter { user in
                    user.id != self.senderId
                }
            })
            .bind(to: self.receivers)
            .disposed(by: self.disposeBag)
        
        self.allUsers
            .map({ users in
                users.filter { user in
                    user.id == self.senderId
                }
            })
            .bind(to: self.sender)
            .disposed(by: self.disposeBag)
        
//        self.allMessage
//            .filter({ messages in
//                messages.contains { message in
//                    (message.senderId == self.senderId && message.receiverId == receiver.id && !message.senderDeleted) || (message.senderId == receiver.id && message.receiverId == self.senderId && !message.receiverDeleted)
//                }
//            })
//            .map({ message in
//                return [receiver.id : message.last!]
//            })
//            .bind(to: self.message)
//            .disposed(by: self.disposeBag)
        
//        self.message
//            .subscribe(onNext: {
//                print($0.count)
//        }).disposed(by: self.disposeBag)
        
        self.view?.didFetchData(self.receivers, self.message)
    }
    
    func filterData(text: String) {
        
    }
    
    func searchUser(_ textField: UITextField) {
//        textField.rx.controlEvent(.editingChanged)
//            .subscribe(onNext: { [weak self] _ in
//                guard let text = textField.text, let receivers = self?.receivers else { return }
//                self?.searchData = text.isEmpty ? receivers : receivers.filter {
//                    $0.name.lowercased().contains(text.lowercased())
//                }
//            })
//            .disposed(by: disposeBag)
    }
}
