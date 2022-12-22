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
    private var messages = [Message]()
    private var users = [User]()
    
    // MARK: Register
    func register(_ name: String,_ username: String,_ password: String,_ imgUrl: String, completed: @escaping () -> Void) {
        let docRef = self.db.collection(Constant.DB_USER).document(username)
        docRef.setData([
            "id": username,
            "username": username,
            "password": password,
            "name": name,
            "imgUrl": imgUrl
        ])
        completed()
    }
    // MARK: Fetch User
    func fetchUser(completed: @escaping ([User]) -> Void) {
        self.db.collection(Constant.DB_USER).addSnapshotListener { [weak self] querySnapshot, err in
            guard let querySnapshot = querySnapshot, err == nil else { return }
            self?.users.removeAll()
            querySnapshot.documents.forEach { document in
                let user = User(user: document.data())
                self?.users.append(user)
            }
            completed(self?.users ?? [])
        }
    }
    
    // MARK: fetch all message
    func fetchMessage(completed: @escaping ([Message]) -> Void) {
        self.db.collection(Constant.DB_MESSAGE).addSnapshotListener { [weak self] querySnapshot, err in
            guard let querySnapshot = querySnapshot, err == nil else { return }
            self?.messages.removeAll()
            querySnapshot.documents.forEach { document in
                let message = Message(message: document.data())
                if message.senderDeleted && message.receiverDeleted {
                    self?.db.collection(Constant.DB_MESSAGE).document(message.messageId).delete()
                }
                self?.messages.append(message)
                self?.messages = self?.messages.sorted {
                    return $0.time < $1.time
                } ?? []
            }
            completed(self?.messages ?? [])
        }
    }
    
    // MARK: fetch avt url
    func fetchAvtUrl(img: UIImage, completed: @escaping (String) -> Void) {
        let img = img.jpegData(compressionQuality: 0.5)!
        let keyImg = NSUUID().uuidString
        let imgFolder = storage.child(Constant.DB_IMAGE_AVATAR).child(keyImg)
        storage.child(Constant.DB_IMAGE_AVATAR).child(keyImg).putData(img) { _ , err in
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
    func changeName(_ id: String,_ name: String, completed: @escaping () -> Void) {
        self.db.collection(Constant.DB_USER).document(id).updateData(["name": name])
        completed()
    }
    
    // MARK: change password
    func changePassword(_ id: String,_ password: String, completed: @escaping () -> Void) {
        self.db.collection(Constant.DB_USER).document(id).updateData(["password": password])
        completed()
    }
    
    // MARK: send message
    func sendMessage(_ text: String,_ receiver: User,_ sender: User) {
        let autoKey = self.db.collection(Constant.DB_MESSAGE).document().documentID
        let docRef = self.db.collection(Constant.DB_MESSAGE).document(autoKey)
        docRef.setData([
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
        ])
    }
    
    // MARK: send image
    func sendImg(_ img: UIImage,_ receiver: User,_ sender: User, completed: @escaping () -> Void) {
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
                docRef.setData([
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
                ])
            }
            completed()
        }
    }
    
    // MARK: Send Reaction
    func sendReaction(_ id: String, _ reaction: String) {
        self.db.collection(Constant.DB_MESSAGE).document(id).updateData(["reaction" : reaction])
    }
    
    // MARK: set state from unread to read
    func setStateUnreadMessage(_ sender: User, _ receiver: User) {
        self.db.collection(Constant.DB_MESSAGE).whereField("read", isEqualTo: false).getDocuments { [weak self] querySnapshot, error in
            guard let querySnapshot = querySnapshot else { return }
            if error != nil { return }
            querySnapshot.documents.forEach { document in
                let message = Message(message: document.data())
                if message.senderId == receiver.id && message.receiverId == sender.id {
                    self?.setMessageState(id: message.messageId)
                }
            }
        }
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
    
    // MARK: set state is read when tap to new message
    private func setMessageState(id: String) {
        self.db.collection(Constant.DB_MESSAGE).whereField("messageId", isEqualTo: id).getDocuments { [weak self] (result, error) in
            guard let result = result else { return }
            if error != nil { return }
            result.documents.forEach { _ in
                self?.db.collection(Constant.DB_MESSAGE).document(id).updateData(["read" : true])
            }
        }
    }
    
    // MARK: Set User State
    func setStateIsActive(_ id: String, _ isActive: Bool) {
        self.db.collection(Constant.DB_USER).document(id).updateData(["isActive" : isActive])
    }
}
