//
//  ListPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 08/12/2022.
//

import Foundation

protocol ListProtocol: AnyObject {
    
}

class ListPresenter {
    
    // MARK: - Properties
    private weak var view: ListProtocol?
    private var receivers = [User]()
    private var sender: User?
    private var searchData = [User]()
    private var allMessage = [Message]()
    private var message: [String: Message] = [:]
    private var senderId: String = ""
    
    // MARK: - Init
    init(view: ListProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - Setter
    func getNumberOfUser() -> Int {
        return self.searchData.count
    }
    
    func getUserBy(index: Int) -> User? {
        return self.searchData[index]
    }
    
    func getMessageBy(id: String) -> Message? {
        return self.message[id]
    }
    
    func setData(_ id: String) {
        self.senderId = id
    }
    
    func setState(_ sender: User, _ receiver: User) {
        FirebaseService.shared.setStateUnreadMessage(sender, receiver)
    }
    
    func getSender() -> User? {
        return self.sender
    }
    
    // MARK: - Data Handler Methods
    func fetchUser(completed: @escaping () -> Void) {
        FirebaseService.shared.fetchUser { [weak self] users in
            self?.receivers.removeAll()
            self?.searchData.removeAll()
            users.forEach { user in
                guard let senderId = self?.senderId else { return }
                if user.id == senderId {
                    self?.sender = user
                } else {
                    self?.receivers.append(user)
                }
            }
            guard let receivers = self?.receivers else { return }
            self?.searchData = receivers
            completed()
        }
    }
    
    func fetchMessage(completed: @escaping () -> Void) {
        self.message.removeAll()
        FirebaseService.shared.fetchMessage { [weak self] messages in
            self?.receivers.forEach { receiver in
                self?.allMessage.removeAll()
                guard let senderId = self?.senderId else { return }
                messages.forEach { message in
                    if (message.senderId == senderId && message.receiverId == receiver.id) || (message.senderId == receiver.id && message.receiverId == senderId) {
                        if self?.sender?.id == message.senderId && !message.senderDeleted {
                            self?.allMessage.append(message)
                        }
                        
                        if self?.sender?.id == message.receiverId && !message.receiverDeleted {
                            self?.allMessage.append(message)
                        }
                    }
                }
                self?.message[receiver.id] = self?.allMessage.last
            }
            completed()
        }
    }
    
    func filterData(text: String) {
        self.searchData = text.isEmpty ? receivers : receivers.filter {
            $0.name.lowercased().contains(text.lowercased())
        }
    }
}
