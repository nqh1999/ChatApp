//
//  DetailPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 08/12/2022.
//

import UIKit
import RxSwift
import RxRelay

protocol DetailProtocol: AnyObject {
    func didGetFetchUserResult(_ user: User)
    func didGetFetchMessageResult(_ messages: BehaviorRelay<[Message]>,_ sender: User?)
    func didGetDeleteMessageResult()
    func didGetSendImageResult()
    func didSendMessage()
}

class DetailPresenter {
    
    // MARK: - Properties
    private weak var view: DetailProtocol?
    private var sender: User?
    private var receiver: User?
    private let allMessages = BehaviorRelay<[Message]>(value: [])
    private var senderLastMessage = [String: String]()
    private var receiverLastMessage = [String: String]()
    private let disposeBag = DisposeBag()
    
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
        return self.allMessages.value.count
    }
    
    func getMessageBy(index: Int) -> Message {
        return self.allMessages.value[index]
    }
    
    // MARK: - Data Handler Methods
    func fetchMessage() {
        FirebaseService.shared.fetchMessage { [weak self] messages in
            guard let sender = self?.sender, let receiver = self?.receiver else { return }
            let arr = messages.filter { message in
                (message.receiverId == receiver.id && message.senderId == sender.id && !message.senderDeleted) || (message.receiverId == sender.id && message.senderId == receiver.id && !message.receiverDeleted)
            }
            self?.allMessages.accept(arr)
        }
        
        self.view?.didGetFetchMessageResult(self.allMessages, self.sender)
    }
    
    func setState() {
        guard let sender = self.sender, let receiver = self.receiver else { return }
        FirebaseService.shared.setStateUnreadMessage(sender, receiver)
    }
    
    func deleteAllMessage() {
//        guard let id = self.sender?.id else { return }
//        self.allMessages.value.forEach { message in
//            FirebaseService.shared.setMessageDelete(id, message)
//        }
        self.view?.didGetDeleteMessageResult()
    }
    
    func sendMessage(_ text: String) {
        guard let receiver = self.receiver, let sender = self.sender else { return }
        if text.isEmpty { return }
        FirebaseService.shared.sendMessage(text, receiver, sender, self.senderLastMessage, self.receiverLastMessage)
        self.view?.didSendMessage()
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
