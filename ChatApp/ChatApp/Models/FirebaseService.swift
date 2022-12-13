//
//  FirebaseService.swift
//  ChatApp
//
//  Created by BeeTech on 12/12/2022.
//

import Firebase

class FirebaseService {
    // MARK: - Properties
    private var db = Firestore.firestore()
    private var storage = Storage.storage().reference()
    private var messages = [Message]()
    private var users = [User]()
    
    // MARK: - Handler Methods
    func fetchUser(completed: @escaping ([User]) -> Void) {
        self.db.collection("user").addSnapshotListener { querySnapshot, err in
            guard let querySnapshot = querySnapshot, err == nil else { return }
            self.users.removeAll()
            querySnapshot.documents.forEach { document in
                let user = User(user: document.data())
                self.users.append(user)
            }
            completed(self.users)
        }
    }
    
    // MARK: fetch all message
    func fetchMessage(completed: @escaping ([Message]) -> Void) {
        self.db.collection("message").addSnapshotListener { querySnapshot, err in
            guard let querySnapshot = querySnapshot, err == nil else { return }
            self.messages.removeAll()
            querySnapshot.documents.forEach { document in
                let message = Message(message: document.data())
                self.messages.append(message)
                self.sortedMessage()
            }
            completed(self.messages)
        }
    }
    
    // MARK: fetch avt url
    func fetchAvtUrl(img: UIImage, completed: @escaping (String) -> Void) {
        let img = img.jpegData(compressionQuality: 0.5)!
        let keyImg = NSUUID().uuidString
        let imgFolder = storage.child("img_avt").child(keyImg)
        storage.child("img_avt").child(keyImg).putData(img) { _ , err in
            guard err == nil else { return }
            imgFolder.downloadURL { url, err in
                guard err == nil, let url = url else { return }
                completed(url.absoluteString)
            }
        }
    }
    
    // MARK: send message to firestore
    func sendMessage(_ text: String,_ receiver: User,_ sender: User) {
        let autoKey = self.db.collection("message").document().documentID
        let docRef = self.db.collection("message").document(autoKey)
        docRef.setData([
            "messageId": autoKey,
            "receiverId": receiver.id,
            "senderId": sender.id,
            "text": text,
            "img": "",
            "time": Date.now.timeIntervalSince1970,
            "read": false
        ])
    }
    
    // MARK: send image to storage
    func sendImg(_ img: UIImage,_ receiver: User,_ sender: User, completed: @escaping () -> Void) {
        let img = img.jpegData(compressionQuality: 0.5)!
        let keyImg = NSUUID().uuidString
        let imgFolder = storage.child("img_message").child(keyImg)
        storage.child("img_message").child(keyImg).putData(img) { _ , err in
            guard err == nil else { return }
            imgFolder.downloadURL { url, err in
                guard err == nil, let url = url else { return }
                let autoKey = self.db.collection("message").document().documentID
                let docRef = self.db.collection("message").document(autoKey)
                docRef.setData([
                    "messageId": autoKey,
                    "receiverId": receiver.id,
                    "senderId": sender.id,
                    "text": "",
                    "img": url.absoluteString,
                    "time": Date.now.timeIntervalSince1970,
                    "read": false
                ])
            }
            completed()
        }
    }
    
    // MARK: set state from unread to read
    func setStateUnreadMessage(_ sender: User, _ receiver: User) {
        self.db.collection("message").whereField("read", isEqualTo: false).getDocuments { querySnapshot, error in
            guard let querySnapshot = querySnapshot else { return }
            if error != nil { return }
            querySnapshot.documents.forEach { document in
                let message = Message(message: document.data())
                if (message.senderId == sender.id && message.receiverId == receiver.id) || (message.senderId == receiver.id && message.receiverId == sender.id) {
                    self.setState(id: message.messageId)
                }
            }
        }
    }
    
    // MARK: delete message
    func delete(id: String) {
        self.db.collection("message").document(id).delete()
    }
    
    // MARK: set state is read when tap to new message
    func setState(id: String) {
        self.db.collection("message").whereField("messageId", isEqualTo: id).getDocuments { (result, error) in
            guard let result = result else { return }
            if error != nil { return }
            result.documents.forEach {_ in
                self.db.collection("message").document(id).updateData(["read" : true])
            }
        }
    }
    
    // MARK: sort message by time
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
}
