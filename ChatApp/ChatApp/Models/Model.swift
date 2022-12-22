//
//  Model.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation

struct Emoji {
    static let like = "👍"
    static let heart = "❤️"
    static let wow = "😮"
    static let haha = "😆"
    static let sad = "😢"
    static let angry = "😠"
}

struct Error {
    static let nameIsEmpty = "Fullname can't be blank"
    static let usernameIsEmpty = "Username can't be blank"
    static let passwordIsEmpty = "Password can't be blank"
    static let currentPasswordIsEmpty = "Current password can't be blank"
    static let newPasswordIsEmpty = "New password can't be blank"
    static let reEnterNewPasswordIsEmpty = "You can re-enter new password"
    static let imgIsEmpty = "Please choose your image"
    static let invalidUsername = "Invalid username"
    static let invalidPassword = "Invalid password"
    static let passwordIncorrect = "Password is incorrect"
    static let usernameIncorrect = "Username is incorrect"
    static let passwordNotSame = "Re-entered password is incorrect"
    static let usernameExist = "Username already exists"
    static let loginSuccess = "Login success"
    static let registerSuccess = "Register Success"
    static let changePasswordSuccess = "Change password success"
    static let loginFailed = "Login failed"
}

struct DBName {
    static let user = "user"
    static let message = "message"
    static let imgMessage = "img_message"
    static let imgAvt = "img_avt"
}

class Constant {

    public static let EXT_INFO = [
        "appVersion": "1.0.0",
    ]
    public static let ZALO_APP_ID = "997497054471494660"

}

enum UserDefaultsKeys: String, CaseIterable {
    case refreshToken = "refreshToken"
    case accessToken = "accessToken"
    case expriedTime = "expriedTime"
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
