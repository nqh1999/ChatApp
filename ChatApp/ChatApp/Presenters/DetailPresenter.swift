//
//  DetailPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 08/12/2022.
//

import Foundation
import Firebase

protocol DetailProtocol: AnyObject {

}

class DetailPresenter {
    
    // MARK: - Properties
    private weak var view: DetailProtocol?
    private var db = Firestore.firestore()
    private var storage = Storage.storage().reference()
    private var sender: User?
    private var receiver: User?
    private var messages = [Message]()
    
    // MARK: - Init
    init(view: DetailProtocol) {
        self.view = view
    }
    
    // MARK: - Getter - Setter
    func setData(sender: User, receiver: User) {
        self.sender = sender
        self.receiver = receiver
    }
    
    func getNumberOfMessage() -> Int {
        return self.messages.count
    }
    
    func getMessageByIndex(index: Int) -> Message {
        return self.messages[index]
    }
    
    func getReceiver() -> User? {
        return self.receiver
    }
    
    func getSender() -> User? {
        return self.sender
    }
    
    // MARK: Handler Methods
    // fetch message
    func fetchMessage(completed: @escaping () -> Void) {
        self.db.collection("message").addSnapshotListener { querySnapshot, err in
            guard let querySnapshot = querySnapshot, let sender = self.sender, let receiver = self.receiver, err == nil else { return completed() }
            self.messages.removeAll()
            querySnapshot.documents.forEach { document in
                let message = Message(message: document.data())
                if (message.receiverId == receiver.id && message.senderId == sender.id) || (message.receiverId == sender.id && message.senderId == receiver.id) {
                    self.messages.append(message)
                    self.sortedMessage()
                }
            }
            completed()
        }
    }
    
    // sort message by time
    private func sortedMessage() {
        var timeArr: [Double] = []
        var messageArr = [Message]()
        self.messages.forEach { message in
            timeArr.append(message.time)
        }
        timeArr.sort {
            $0 < $1
        }
        timeArr.forEach { time in
            self.messages.forEach { message in
                if message.time == time {
                    messageArr.append(message)
                }
            }
        }
        self.messages = messageArr
    }
    
    // Send message To DB
    func sendMessage(text: String) {
        let docRef = self.db.collection("message")
        guard let receiver = self.receiver, let sender = self.sender else { return }
        if text.isEmpty { return }
        docRef.addDocument(data: [
                "receiverId": receiver.id,
                "senderId": sender.id,
                "text": text,
                "img": "",
                "time": Date.now.timeIntervalSince1970
        ])
    }
    
    // Send img url To DB
    func sendImg(img: UIImage, completed: @escaping () -> Void) {
        let img = img.jpegData(compressionQuality: 0.5)!
        let keyImg = NSUUID().uuidString
        let imgFolder = storage.child("img_message").child(keyImg)
        storage.child("img_message").child(keyImg).putData(img) { _ , err in
            guard err == nil else { return }
            imgFolder.downloadURL { url, err in
                guard err == nil, let url = url, let sender = self.sender, let receiver = self.receiver else { return }
                let docRef = self.db.collection("message")
                docRef.addDocument(data: [
                    "receiverId": receiver.id,
                    "senderId": sender.id,
                    "text": "",
                    "img": url.absoluteString,
                    "time": Date.now.timeIntervalSince1970
                ])
            }
            completed()
        }
    }
}
