//
//  FirebaseService.swift
//  ChatApp
//
//  Created by BeeTech on 12/12/2022.
//

import Foundation
import Firebase

class FirebaseService {
    // MARK: - Properties
    private var db = Firestore.firestore()
    private var messages = [Message]()
    private var users = [User]()
    
    // fetch user
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
    
    // fetch message
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
}
