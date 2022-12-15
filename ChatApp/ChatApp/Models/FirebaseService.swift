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
    
    // MARK: Register
    func register(_ id: Int,_ name: String,_ username: String,_ password: String,_ imgUrl: String, completed: @escaping () -> Void) {
        let docRef = self.db.collection("user").document("\(id)")
        docRef.setData([
            "id": id,
            "username": username,
            "password": password,
            "name": name,
            "imgUrl": imgUrl
        ])
        completed()
    }
    // MARK: Fetch User
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
                self.messages = self.messages.sorted {
                    return $0.time < $1.time
                }
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
    
    
    // MARK: change avt
    func changeAvt(_ id: Int,_ img: UIImage, completed: @escaping () -> Void) {
        let img = img.jpegData(compressionQuality: 0.5)!
        let keyImg = NSUUID().uuidString
        let imgFolder = storage.child("img_avt").child(keyImg)
        storage.child("img_avt").child(keyImg).putData(img) { _ , err in
            guard err == nil else { return }
            imgFolder.downloadURL { url, err in
                guard err == nil, let url = url else { return }
                self.db.collection("user").document("\(id)").updateData(["imgUrl" : url.absoluteString])
                completed()
            }
        }
    }
    
    // MARK: change name
    func changeName(_ id: Int,_ name: String, completed: @escaping () -> Void) {
        self.db.collection("user").document("\(id)").updateData(["name": name])
        completed()
    }
    
    // MARK: change password
    func changePassword(_ id: Int,_ password: String, completed: @escaping () -> Void) {
        self.db.collection("user").document("\(id)").updateData(["password": password])
        completed()
    }
    
    // MARK: send message
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
    
    // MARK: send image
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
                if message.senderId == receiver.id && message.receiverId == sender.id {
                    self.setMessageState(id: message.messageId)
                }
            }
        }
    }
    
    // MARK: delete message
    func delete(id: String) {
        self.db.collection("message").document(id).delete()
    }
    
    // MARK: set state is read when tap to new message
    private func setMessageState(id: String) {
        self.db.collection("message").whereField("messageId", isEqualTo: id).getDocuments { (result, error) in
            guard let result = result else { return }
            if error != nil { return }
            result.documents.forEach {_ in
                self.db.collection("message").document(id).updateData(["read" : true])
            }
        }
    }
    
    // MARK: Set User State
    func setStateIsActive(_ id: Int, _ isActive: Bool) {
        self.db.collection("user").document("\(id)").updateData(["isActive" : isActive])
    }
}
