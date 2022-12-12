//
//  ListPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 08/12/2022.
//

import Foundation
import Firebase

protocol ListProtocol: AnyObject {
    
}

class ListPresenter {
    
    // MARK: - Properties
    private weak var view: ListProtocol?
    private var db = Firestore.firestore()
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
        return self.searchData[index]
    }
    
    func getMessageById(_ id: Int) -> Message? {
        return message[id]
    }
    
    func setData(_ id: Int) {
        self.senderId = id
    }
    
    func fetchUser(completed: @escaping () -> Void) {
        self.receivers.removeAll()
        self.allMessage.removeAll()
        self.service.fetchUser { users in
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
    
    func getSender() -> User? {
        return self.sender
    }
    
    func removeReceiverAt(index: Int) {
        self.searchData.remove(at: index)
    }
    
    // MARK: - Handler Methods
    // fill data after search
    func filterData(text: String) {
        self.searchData = text.isEmpty ? receivers : receivers.filter {
            $0.name.lowercased().contains(text.lowercased())
        }
    }
}
