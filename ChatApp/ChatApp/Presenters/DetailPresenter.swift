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
    // MARK: - Properties
    private weak var view: DetailProtocol?
    private var db = Firestore.firestore()
    private var storage = Storage.storage().reference()
    private var currentUser: UserDetail? = nil
    private var currentId: Int = 0
    private var receiverData: UserDetail?
    private var messages = [Message]()
    // MARK: - Init
    init(view: DetailProtocol) {
        self.view = view
    }
    // MARK: - Getter - Setter
    func setReceiver(data: UserDetail) {
        self.receiverData = data
    }
    
    func getReceiver() -> UserDetail? {
        return receiverData
    }
    
    func setCurrentId(id: Int) {
        self.currentId = id
    }
    
    func getCurrentId() -> Int {
        return currentId
    }
    func getNumberOfMessage() -> Int {
        return self.messages.count
    }
    
    func getMessageByIndex(index: Int) -> Message {
        return self.messages[index]
    }
    // MARK: Handler Methods
    func fetchMessage() {
        self.messages.removeAll()
        self.db.collection("message").getDocuments() { querySnapshot, err in
            if err != nil {
                print(err!.localizedDescription)
            } else {
                guard let querySnapshot = querySnapshot, let receiverData = self.receiverData  else { return }
                querySnapshot.documents.forEach { document in
                    let message = document.data() as [String: Any]
                    let value = Message(message: message)
                    if value.receiverId == receiverData.id && value.senderId == self.currentId {
                        self.messages.append(value)
                    }
                    self.view?.didGetMessage()
                }
            }
        }
    }
    // Send Data To DB
    func sendMessage(text: String) {
        let docRef = self.db.collection("message")
        guard let receiverData = self.receiverData else {return}
        if !text.isEmpty {
            docRef.addDocument(data: [
                    "receiverId": receiverData.id,
                    "senderId": currentId,
                    "text": text,
                    "img": "",
                    "time": Date.now
            ]) { err in
                if err != nil {
                    print(err!.localizedDescription)
                } else {
                    print("send message success")
                }
            }
        } else {
            print("No message")
        }
    }
    func sendImg(img: UIImage) {
        let img = img.jpegData(compressionQuality: 0.5)!
        let keyImg = NSUUID().uuidString
        let imgFolder = storage.child("img_message").child(keyImg)
        storage.child("img_message").child(keyImg).putData(img) { _ , err in
            if err != nil {
                print(err!.localizedDescription)
            } else {
                imgFolder.downloadURL { url, err in
                    if err != nil {
                        print(err!.localizedDescription)
                    } else {
                        let docRef = self.db.collection("message")
                        docRef.addDocument(data: [
                            "receiverId": self.receiverData!.id,
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
}
