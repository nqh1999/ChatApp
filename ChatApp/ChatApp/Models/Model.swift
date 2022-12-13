//
//  Model.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation

// MARK: Enum error
enum Err: String {
    case nameIsEmpty = "Fullname can't be blank"
    case usernameIsEmpty = "Username can't be blank"
    case passwordIsEmpty = "Password can't be blank"
    case imgIsEmpty = "Please choose your image"
    case usernameExist = "Username already exists"
    case loginFailed = "username or password is incorrect"
}

// MARK: User Model
struct User {
    var id: Int
    var name: String
    var imgUrl: String
    var username: String
    var password: String
    init(user: [String: Any]) {
        self.id = user["id"] as? Int ?? 0
        self.username = user["username"] as? String ?? ""
        self.password = user["password"] as? String ?? ""
        self.name = user["name"] as? String ?? ""
        self.imgUrl = user["imgUrl"] as? String ?? ""
    }
}

// MARK: Message Model
struct Message {
    var messageId: String
    var receiverId: Int
    var senderId: Int
    var text: String
    var img: String
    var time: Double
    var read: Bool
    init(message: [String: Any]) {
        self.messageId = message["messageId"] as? String ?? ""
        self.receiverId = message["receiverId"] as? Int ?? 0
        self.senderId = message["senderId"] as? Int ?? 0
        self.text = message["text"] as? String ?? ""
        self.img = message["img"] as? String ?? ""
        self.time = message["time"] as? Double ?? 0.0
        self.read = message["read"] as? Bool ?? false
    }
}
