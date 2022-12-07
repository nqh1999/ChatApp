//
//  Model.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import Foundation

struct User {
    var name: String
    var username: String
    var password: String
    init(dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.password = dict["password"] as? String ?? ""
    }
}
