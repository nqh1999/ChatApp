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
    
    // MARK: - Fetch User
    func fetchUser(completed: @escaping () -> Void) {
        self.service.fetchUser { users in
            self.receivers.removeAll()
            self.searchData.removeAll()
            users.forEach { user in
                if user.id == self.senderId {
                    self.sender = user
                } else {
                    self.receivers.append(user)
                }
            }
            self.searchData = self.receivers
            completed()
        }
    }
    
    // MARK: Fetch Message
    func fetchMessage(completed: @escaping () -> Void) {
        self.message.removeAll()
        self.service.fetchMessage { messages in
            self.receivers.forEach { receiver in
                self.allMessage.removeAll()
                messages.forEach { message in
                    if (message.senderId == self.senderId && message.receiverId == receiver.id) || (message.senderId == receiver.id && message.receiverId == self.senderId) {
                        self.allMessage.append(message)
                    }
                }
                self.message[receiver.id] = self.allMessage.last
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
    
    // MARK: search user
    func filterData(text: String) {
        self.searchData = text.isEmpty ? receivers : receivers.filter {
            $0.name.lowercased().contains(text.lowercased())
        }
    }
}
