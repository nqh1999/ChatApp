//
//  DetailPresenter.swift
//  ChatApp
//
//  Created by BeeTech on 08/12/2022.
//

import Foundation
import Firebase

protocol DetailProtocol: AnyObject {
    func didGetMessage()
}

class DetailPresenter {
    private weak var view: DetailProtocol?
    private var db = Firestore.firestore()
    private var storage = Storage.storage().reference()
    private var currentUser: UserDetail? = nil
    private var currentId: Int = 0
    private var friendData: UserDetail?
    private var messages = [Message]()
    init(view: DetailProtocol) {
        self.view = view
    }
    
    func fetchMessage() {
        db.collection("message").getDocuments() { querySnapshot, err in
            if err != nil {
                print(err!.localizedDescription)
            } else {
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {
                    let dict = document.data() as [String: Any]
                    let value = Message(dict: dict)
                    if value.receiverId == self.friendData!.id && value.senderId == self.currentId {
                        self.messages.append(value)
                    }
                    self.view?.didGetMessage()
                }
            }
            print(self.messages)
        }
    }
    
    func getNumberOfMessage() -> Int {
        return messages.count
    }
    
    func getMessageByIndex(index: Int) -> Message {
        return messages[index]
    }
    
    func sendMessage(text: String?) {
        let docRef = db.collection("message")
        guard let text = text else {return}
        docRef.addDocument(data: [
                "receiverId": friendData!.id,
                "senderId": currentId,
                "text": text,
                "img": "",
                "time": Date.now
        ]) { err in
            if err != nil {
                print(err!.localizedDescription)
            } else {
                print("success")
            }
        }
    }
    
    func sendImg(img: UIImage) {
        let img = img.jpegData(compressionQuality: 0.5)!
        let keyImg = NSUUID().uuidString
        let imgFolder = storage.child("img_message").child(keyImg)
        storage.child("img_message").child(keyImg).putData(img) { data, err in
            if err != nil {
                print(err!.localizedDescription)
            } else {
                imgFolder.downloadURL { url, err in
                    if err != nil {
                        print(err!.localizedDescription)
                    } else {
                        let docRef = self.db.collection("message")
                        docRef.addDocument(data: [
                            "receiverId": self.friendData!.id,
                            "senderId": self.currentId,
                            "text": "",
                            "img": url?.absoluteString ?? "",
                            "time": Date.now
                        ]) { err in
                            if err != nil {
                                print(err!.localizedDescription)
                            } else {
                                print("success")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setFriend(data: UserDetail) {
        self.friendData = data
    }
    
    func getFriend() -> UserDetail? {
        return friendData
    }
    
    func setCurrentId(id: Int) {
        self.currentId = id
    }
    
    func getCurrentId() -> Int {
        return currentId
    }
}
