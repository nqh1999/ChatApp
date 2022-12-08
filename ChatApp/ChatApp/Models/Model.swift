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
    init(dict: [String: Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.username = dict["username"] as? String ?? ""
        self.password = dict["password"] as? String ?? ""
    }
}

struct UserDetail {
    var id: Int
    var name: String
    var imgUrl: String
    init(dict: [String: Any]) {
        self.id = dict["id"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
        self.imgUrl = dict["imgUrl"] as? String ?? ""
    }
}

struct Message {
    var receiverId: Int
    var senderId: Int
    var text: String
    var img: String
    var time: Date
    
    init(dict: [String: Any]) {
        self.receiverId = dict["receiverId"] as? Int ?? 0
        self.senderId = dict["senderId"] as? Int ?? 0
        self.text = dict["text"] as? String ?? ""
        self.img = dict["img"] as? String ?? ""
        self.time = dict["time"] as? Date ?? .now
    }
}
