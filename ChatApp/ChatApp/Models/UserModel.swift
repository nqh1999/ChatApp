//
//  UserModel.swift
//  ChatApp
//
//  Created by Nguyen Quang Huy on 12/06/2023.
//

import Foundation

struct User: Equatable {
    var id: String
    var name: String
    var imgUrl: String
    var username: String
    var password: String
    var isActive: Bool
    var lastMessages: [String: String]
    
    init(user: [String: Any]) {
        self.id = user["id"] as? String ?? ""
        self.username = user["username"] as? String ?? ""
        self.password = user["password"] as? String ?? ""
        self.name = user["name"] as? String ?? ""
        self.imgUrl = user["imgUrl"] as? String ?? ""
        self.isActive = user["isActive"] as? Bool ?? false
        self.lastMessages = user["lastMessages"] as? [String: String] ?? [:]
    }
}
