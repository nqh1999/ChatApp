//
//  DetailPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 08/12/2022.
//

import UIKit

protocol DetailProtocol: AnyObject {

}

class DetailPresenter {
    
    // MARK: - Properties
    private weak var view: DetailProtocol?
    private var sender: User?
    private var receiver: User?
    private var messages = [Message]()
    private var service = FirebaseService()
    
    // MARK: - Init
    init(view: DetailProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - Setter
    func setData(_ sender: User,_ receiver: User) {
        self.sender = sender
        self.receiver = receiver
    }
    
    func getNumberOfMessage() -> Int {
        return self.messages.count
    }
    
    func getMessageBy(index: Int) -> Message {
        return self.messages[index]
    }
    
    func getReceiver() -> User? {
        return self.receiver
    }
    
    func getSender() -> User? {
        return self.sender
    }
    
    // MARK: - Data Handler Methods
    func fetchUser(completed: @escaping (User) -> Void) {
        self.service.fetchUser { [weak self] users in
            guard let receiver = self?.receiver else { return }
            users.forEach { user in
                if user.id == receiver.id {
                    completed(user)
                }
            }
        }
    }
    
    func fetchMessage(completed: @escaping () -> Void) {
        self.service.fetchMessage { [weak self] messages in
            guard let sender = self?.sender, let receiver = self?.receiver else { return }
            self?.messages.removeAll()
            messages.forEach { message in
                if (message.receiverId == receiver.id && message.senderId == sender.id) || (message.receiverId == sender.id && message.senderId == receiver.id) {
                    self?.messages.append(message)
                }
            }
            completed()
        }
    }
    
    func setState() {
        guard let sender = self.sender, let receiver = self.receiver else { return }
        self.service.setStateUnreadMessage(sender, receiver)
    }
    
    func deleteAllMessage(_ completed: @escaping () -> Void) {
        self.messages.forEach { message in
            self.service.delete(id: message.messageId)
        }
        completed()
    }
    
    func sendMessage(_ text: String) {
        guard let receiver = self.receiver, let sender = self.sender else { return }
        if text.isEmpty { return }
        self.service.sendMessage(text, receiver, sender)
    }
    
    func sendImg(_ img: UIImage, completed: @escaping () -> Void) {
        guard let receiver = self.receiver, let sender = self.sender else { return }
        self.service.sendImg(img, receiver, sender) {
            completed()
        }
    }
}
