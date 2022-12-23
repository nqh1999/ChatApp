//
//  Model.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation

// MARK: Constant
struct Constant {
    static let EXT_INFO = ["appVersion": "1.0.0"]
    static let ZALO_APP_ID = "997497054471494660"
    
    static let DB_USER = "user"
    static let DB_MESSAGE = "message"
    static let DB_IMAGE_MESSAGE = "img_message"
    static let DB_IMAGE_AVATAR = "img_avt"
    
    static let MESSAGE_IS_EMPTY = "can't be blank"
    static let MESSAGE_IMAGE_IS_EMPTY = "Please choose your image"
    static let MESSAGE_INVALID = "Invalid"
    static let MESSAGE_INCORRECT = "Incorrect"
    static let MESSAGE_COMPARE_FAILED = "Re-entered password is incorrect"
    static let MESSAGE_USERNAME_EXIST = "Username already exists"
    static let MESSAGE_SUCCESS = "Success"
    static let MESSAGE_FAILED = "Failed"
}

// MARK: User Model
struct User {
    var id: String
    var name: String
    var imgUrl: String
    var username: String
    var password: String
    var isActive: Bool
    init(user: [String: Any]) {
        self.id = user["id"] as? String ?? ""
        self.username = user["username"] as? String ?? ""
        self.password = user["password"] as? String ?? ""
        self.name = user["name"] as? String ?? ""
        self.imgUrl = user["imgUrl"] as? String ?? ""
        self.isActive = user["isActive"] as? Bool ?? false
    }
}

// MARK: Message Model
struct Message {
    var messageId: String
    var receiverId: String
    var senderId: String
    var text: String
    var img: String
    var ratio: Double
    var time: Double
    var read: Bool
    var reaction: String
    var senderDeleted: Bool
    var receiverDeleted: Bool
    init(message: [String: Any]) {
        self.messageId = message["messageId"] as? String ?? ""
        self.receiverId = message["receiverId"] as? String ?? ""
        self.senderId = message["senderId"] as? String ?? ""
        self.text = message["text"] as? String ?? ""
        self.img = message["img"] as? String ?? ""
        self.ratio = message["ratio"] as? Double ?? 1
        self.time = message["time"] as? Double ?? 0.0
        self.read = message["read"] as? Bool ?? false
        self.reaction = message["reaction"] as? String ?? ""
        self.senderDeleted = message["senderDeleted"] as? Bool ?? false
        self.receiverDeleted = message["receiverDeleted"] as? Bool ?? false
    }
}
