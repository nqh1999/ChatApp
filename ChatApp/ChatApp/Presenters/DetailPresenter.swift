//
//  DetailPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 08/12/2022.
//

import UIKit

protocol DetailProtocol: AnyObject {
    func didGetFetchUserResult(_ user: User)
    func didGetFetchMessageResult()
    func didGetDeleteMessageResult()
    func didGetSendImageResult()
}

class DetailPresenter {
    
    // MARK: - Properties
    private weak var view: DetailProtocol?
    private var sender: User?
    private var receiver: User?
    private var messages = [Message]()
    private var senderLastMessage = [String: String]()
    private var receiverLastMessage = [String: String]()
    
    // MARK: - Init
    init(view: DetailProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - Setter
    func setData(_ sender: User,_ receiver: User) {
        self.sender = sender
        self.receiver = receiver
        self.view?.didGetFetchUserResult(receiver)
        self.senderLastMessage = sender.lastMessages
        self.receiverLastMessage = receiver.lastMessages
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
    func fetchMessage() {
//        FirebaseService.shared.fetchMessage { [weak self] messages in
//            guard let sender = self?.sender, let receiver = self?.receiver else { return }
//            self?.messages.removeAll()
//            messages.forEach { message in
//                if (message.receiverId == receiver.id && message.senderId == sender.id) || (message.receiverId == sender.id && message.senderId == receiver.id) {
//                    if (self?.sender?.id == message.senderId && !message.senderDeleted) || (self?.sender?.id == message.receiverId && !message.receiverDeleted) {
//                        self?.messages.append(message)
//                    }
//                }
//            }
//            self?.view?.didGetFetchMessageResult()
//        }
    }
    
    func setState() {
        guard let sender = self.sender, let receiver = self.receiver else { return }
        FirebaseService.shared.setStateUnreadMessage(sender, receiver)
    }
    
    func deleteAllMessage() {
        guard let id = self.sender?.id else { return }
        self.messages.forEach { message in
            FirebaseService.shared.setMessageDelete(id, message)
        }
        self.view?.didGetDeleteMessageResult()
    }
    
    func sendMessage(_ text: String) {
        guard let receiver = self.receiver, let sender = self.sender else { return }
        if text.isEmpty { return }
        FirebaseService.shared.sendMessage(text, receiver, sender, self.senderLastMessage, self.receiverLastMessage)
    }
    
    func sendImg(_ img: UIImage) {
        guard let receiver = self.receiver, let sender = self.sender else { return }
        FirebaseService.shared.sendImg(img, receiver, sender, self.senderLastMessage, self.receiverLastMessage) { [weak self] in
            self?.view?.didGetSendImageResult()
        }
    }
    
    func sendReaction(_ id: String, _ reaction: String) {
        FirebaseService.shared.sendReaction(id, reaction)
    }
}
