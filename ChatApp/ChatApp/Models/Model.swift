//
//  Model.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation

struct User {
    var id: Int
    var username: String
    var password: String
    init(user: [String: Any]) {
        self.id = user["id"] as? Int ?? 0
        self.username = user["username"] as? String ?? ""
        self.password = user["password"] as? String ?? ""
    }
}

struct UserDetail {
    var id: Int
    var name: String
    var imgUrl: String
    init(userDetail: [String: Any]) {
        self.id = userDetail["id"] as? Int ?? 0
        self.name = userDetail["name"] as? String ?? ""
        self.imgUrl = userDetail["imgUrl"] as? String ?? ""
    }
}

struct Message {
    var receiverId: Int
    var senderId: Int
    var text: String
    var img: String
    var time: Date
    init(message: [String: Any]) {
        self.receiverId = message["receiverId"] as? Int ?? 0
        self.senderId = message["senderId"] as? Int ?? 0
        self.text = message["text"] as? String ?? ""
        self.img = message["img"] as? String ?? ""
        self.time = message["time"] as? Date ?? .now
    }
}
