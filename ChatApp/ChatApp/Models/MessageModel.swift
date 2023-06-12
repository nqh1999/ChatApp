//
//  MessageModel.swift
//  ChatApp
//
//  Created by Nguyen Quang Huy on 12/06/2023.
//

import Foundation

struct Message: Equatable {
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
