//
//  SharedData.swift
//  ChatApp
//
//  Created by Nguyen Quang Huy on 12/06/2023.
//

import Foundation

class SharedData {
    static let shared = SharedData()
    
    func setUserId(id: String) {
        UserDefaults.standard.set(id, forKey: Constant.userId)
    }
    
    func getUserId() -> String {
        guard let id = UserDefaults.standard.value(forKey: Constant.userId) as? String else { return "" }
        return id
    }
}
