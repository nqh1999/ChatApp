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
    private var message: [Int: Message] = [:]
    private var service = FirebaseService()
    private var senderId: Int = 0
    
    // MARK: - Init
    init(view: ListProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - Setter
    func getNumberOfUser() -> Int {
        return self.searchData.count
    }
    
    func getUserByIndex(index: Int) -> User? {
        self.sortMessage()
        return self.searchData[index]
    }
    
    func getMessageById(_ id: Int) -> Message? {
        return self.message[id]
    }
    
    func setData(_ id: Int) {
        self.senderId = id
    }
    
    func setState(_ sender: User, _ receiver: User) {
        self.service.setStateUnreadMessage(sender, receiver)
    }
    
    func getSender() -> User? {
        return self.sender
    }
    
    // MARK: - Data Handler Methods
    func fetchUser(completed: @escaping () -> Void) {
        self.service.fetchUser { [weak self] users in
            self?.receivers.removeAll()
            self?.searchData.removeAll()
            users.forEach { user in
                if user.id == self!.senderId {
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
        self.service.fetchMessage { [weak self] messages in
            self?.receivers.forEach { receiver in
                self?.allMessage.removeAll()
                guard let senderId = self?.senderId else { return }
                messages.forEach { message in
                    if (message.senderId == senderId && message.receiverId == receiver.id) || (message.senderId == receiver.id && message.receiverId == senderId) {
                        self?.allMessage.append(message)
                    }
                }
                self?.message[receiver.id] = self?.allMessage.last
            }
            completed()
        }
    }
    
    // sort by time
    func sortMessage() {
//        self.searchData = self.searchData.sorted {
//            guard let preUser = self.message[$0.id], let nextUser = self.message[$1.id] else { return false }
//            return preUser.time > nextUser.time
//        }
    }
    
    func filterData(text: String) {
        self.searchData = text.isEmpty ? receivers : receivers.filter {
            $0.name.lowercased().contains(text.lowercased())
        }
    }
}
