//
//  ValidateService.swift
//  ChatApp
//
//  Created by BeeTech on 15/12/2022.
//

import Foundation

class ValidateService {
    static let shared = ValidateService()
    
    // MARK: Check login data
    func checkLogin(_ users: [User], _ username: String, _ password: String, completed: (Bool, String) -> Void) {
        var result: Bool = false
        var senderId: String = ""
        users.forEach { user in
            if user.username == username && user.password == password {
                result = true
                senderId = user.id
            }
        }
        completed(result, senderId)
    }
    
    // MARK: Check register data
    func checkRegisterData(_ users: [User], _ name: String,_ username: String,_ password: String, _ imgUrl: String, completed: (String?) -> Void) {
        
        if users.contains(where: { user in
            user.username == username
        }) {
            completed(L10n.usernameIsExist)
            return
        }
        
        if name.isEmpty {
            completed(L10n.enterName)
            return
        }
        
        if username.isEmpty {
            completed(L10n.enterUsername)
            return
        }
        
        if !username.isValidEmail {
            completed(L10n.invalidUsername)
            return
        }
        
        if password.isEmpty {
            completed(L10n.enterPassword)
            return
        }
        
        if password.count < 6 {
            completed(L10n.invalidPassword)
            return
        }
        
        if imgUrl.isEmpty {
            completed(L10n.enterImage)
            return
        }
        
        completed(nil)
    }
    
    // MARK: Check change password data
    func checkChangePasswordData(_ user: User, _ currentPassword: String, _ newPassword: String, _ reEnterNewPassword: String, completed: (String?) -> Void) {
        if currentPassword.isEmpty {
            completed(L10n.enterCurrentPassword)
            return
        }
        
        if currentPassword != user.password {
            completed(L10n.incorrectCurrentPassword)
            return
        }
        
        if newPassword.isEmpty {
            completed(L10n.enterNewPassword)
            return
        }
        
        if reEnterNewPassword.isEmpty {
            completed(L10n.enterReEnterPassword)
            return
        }
        
        if newPassword.count < 6 {
            completed(L10n.invalidNewPassword)
            return
        }
        
        if newPassword != reEnterNewPassword {
            completed(L10n.compareFailed)
            return
        }
        
        completed(nil)
    }
    
    // MARK: Check username
    func checkUsername(_ users: [User], _ username: String, completed: (String?, String) -> Void) {
        var userId: String = ""
        userId = users.filter { user in
            user.username == username
        }.first?.id ?? ""
        
        if username.isEmpty {
            completed(L10n.enterUsername, userId)
            return
        }
        
        if users.contains(where: { user in
            user.username == username
        }) {
            completed(nil, userId)
            return
        }
        
        completed(L10n.invalidUsername, userId)
    }
}
