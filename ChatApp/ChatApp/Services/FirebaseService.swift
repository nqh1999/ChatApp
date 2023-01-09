//
//  FirebaseService.swift
//  ChatApp
//
//  Created by BeeTech on 12/12/2022.
//

import Firebase
import FirebaseAuth

class FirebaseService {
    
    // MARK: - Properties
    static let shared = FirebaseService()
    private var db = Firestore.firestore()
    private var storage = Storage.storage().reference()
    
    // MARK: Register
    func register(_ name: String,_ username: String,_ password: String,_ imgUrl: String, completed: @escaping () -> Void) {
        self.db.collection(Constant.DB_USER).document(username).setData([
            "id": username,
            "username": username,
            "password": password,
            "name": name,
            "imgUrl": imgUrl,
            "lastMessageId": ""
        ]) { _ in
            completed()
        }
    }
    
    // MARK: Fetch User
    
    func fetchUser(completed: @escaping (([User])-> Void)) {
        self.db.collection(Constant.DB_USER).addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot else { return }
            let users = querySnapshot.documents.map { User(user: $0.data())}
            completed(users)
        }
    }
    
    // MARK: fetch all message
    func fetchMessage(completed: @escaping (([Message])-> Void)) {
        self.db.collection(Constant.DB_MESSAGE).addSnapshotListener { querySnapshot, err in
            guard let querySnapshot = querySnapshot, err == nil else { return }
            let messages = querySnapshot.documents.map {
                Message(message: $0.data())
            }.sorted {
                $0.time < $1.time
            }
            completed(messages)
        }
    }
    
    // MARK: Fetch Message by id
    func fetchMessageById(_ id: String, completed: @escaping ((Message?)-> Void)){
        self.db.collection(Constant.DB_MESSAGE).document(id).addSnapshotListener { querySnapshot, err in
            guard let data = querySnapshot?.data(), err == nil else {
                return
            }
            completed(Message(message: data))
        }
    }
    
    // MARK: fetch avt url
    func fetchAvtUrl(img: UIImage, completed: @escaping (String) -> Void) {
        let img = img.jpegData(compressionQuality: 0.5)!
        let keyImg = NSUUID().uuidString
        let imgFolder = self.storage.child(Constant.DB_IMAGE_AVATAR).child(keyImg)
        self.storage.child(Constant.DB_IMAGE_AVATAR).child(keyImg).putData(img) { _ , err in
            guard err == nil else { return }
            imgFolder.downloadURL { url, err in
                guard err == nil, let url = url else { return }
                completed(url.absoluteString)
            }
        }
    }
    
    
    // MARK: change avt
    func changeAvt(_ id: String,_ img: UIImage, completed: @escaping () -> Void) {
        let img = img.jpegData(compressionQuality: 0.5)!
        let keyImg = NSUUID().uuidString
        let imgFolder = storage.child(Constant.DB_IMAGE_AVATAR).child(keyImg)
        storage.child(Constant.DB_IMAGE_AVATAR).child(keyImg).putData(img) { [weak self] _ , err in
            guard err == nil else { return }
            imgFolder.downloadURL { [weak self] url, err in
                guard err == nil, let url = url else { return }
                self?.db.collection(Constant.DB_USER).document(id).updateData(["imgUrl" : url.absoluteString])
                completed()
            }
        }
    }
    
    // MARK: change name
    func changeName(_ id: String,_ name: String) {
        self.db.collection(Constant.DB_USER).document(id).updateData(["name": name])
    }
    
    // MARK: change password
    func changePassword(_ id: String,_ password: String, completed: @escaping () -> Void) {
        self.db.collection(Constant.DB_USER).document(id).updateData(["password": password]) { _ in
            completed()
        }
    }
    
    // MARK: send message
    func sendMessage(_ text: String,_ receiver: User,_ sender: User, _ senderLastMessages: [String: String], _ receiverLastMessages: [String: String]) {
        let autoKey = self.db.collection(Constant.DB_MESSAGE).document().documentID
        let ref = self.db.collection(Constant.DB_MESSAGE).document(autoKey)
        let message: [String: Any] = [
            "messageId": autoKey,
            "receiverId": receiver.id,
            "senderId": sender.id,
            "text": text,
            "img": "",
            "ratio": 0,
            "time": Date.now.timeIntervalSince1970,
            "read": false,
            "reaction": "",
            "senderDeleted": false,
            "receiverDeleted": false
        ]
        ref.setData(message)
        self.updateMessage(ref.documentID, sender, receiver, senderLastMessages, receiverLastMessages)
    }
    
    // MARK: send image
    func sendImg(_ img: UIImage,_ receiver: User,_ sender: User, _ senderLastMessages: [String: String], _ receiverLastMessages: [String: String], completed: @escaping () -> Void) {
        let ratio = img.size.width / img.size.height
        let img = img.jpegData(compressionQuality: 0.5)!
        let keyImg = NSUUID().uuidString
        let imgFolder = storage.child(Constant.DB_IMAGE_MESSAGE).child(keyImg)
        storage.child(Constant.DB_IMAGE_MESSAGE).child(keyImg).putData(img) { [weak self] _ , err in
            guard err == nil else { return }
            imgFolder.downloadURL { url, err in
                guard err == nil, let url = url else { return }
                guard let autoKey = self?.db.collection(Constant.DB_MESSAGE).document().documentID else { return }
                guard let docRef = self?.db.collection(Constant.DB_MESSAGE).document(autoKey) else { return }
                let message: [String: Any] = [
                    "messageId": autoKey,
                    "receiverId": receiver.id,
                    "senderId": sender.id,
                    "text": "",
                    "img": url.absoluteString,
                    "ratio": ratio,
                    "time": Date.now.timeIntervalSince1970,
                    "read": false,
                    "reaction": "",
                    "senderDeleted": false,
                    "receiverDeleted": false
                ]
                docRef.setData(message)
                self?.updateMessage(docRef.documentID, sender, receiver, senderLastMessages, receiverLastMessages)
            }
            completed()
        }
    }
    
    private func updateMessage(_ ref: String,_ sender: User,_ receiver: User, _ senderLastMessages: [String: String], _ receiverLastMessages: [String: String]) {
        var senderLastMessage = senderLastMessages
        var receiverLastMessage = receiverLastMessages
        senderLastMessage[receiver.id] = ref
        receiverLastMessage[sender.id] = ref
        self.db.collection(Constant.DB_USER).document(sender.id).updateData(["lastMessages" : senderLastMessage])
        self.db.collection(Constant.DB_USER).document(receiver.id).updateData(["lastMessages" : receiverLastMessage])
    }
    
    // MARK: Send Reaction
    func sendReaction(_ id: String, _ reaction: String) {
        self.db.collection(Constant.DB_MESSAGE).document(id).updateData(["reaction" : reaction])
    }
    
    // MARK: Set Delete Message
    func setMessageDelete(_ senderId: String, _ message: Message) {
        if senderId == message.senderId {
            self.db.collection(Constant.DB_MESSAGE).document(message.messageId).updateData([
                "senderDeleted": true
            ])
            return
        }
        
        if senderId == message.receiverId {
            self.db.collection(Constant.DB_MESSAGE).document(message.messageId).updateData([
                "receiverDeleted": true
            ])
            return
        }
    }
    
    // MARK: set state message
    func setStateUnreadMessage(_ sender: User, _ receiver: User) {
        self.db.collection(Constant.DB_MESSAGE).whereField("read", isEqualTo: false).getDocuments { [weak self] querySnapshot, error in
            guard let querySnapshot = querySnapshot else { return }
            if error != nil { return }
            querySnapshot.documents.forEach { document in
                let message = Message(message: document.data())
                if message.senderId == receiver.id && message.receiverId == sender.id {
                    self?.db.collection(Constant.DB_MESSAGE).document(message.messageId).updateData(["read" : true])
                }
            }
        }
    }
    
    // MARK: Set User State
    func setStateIsActive(_ id: String, _ isActive: Bool) {
        self.db.collection(Constant.DB_USER).document(id).updateData(["isActive" : isActive])
    }
}
