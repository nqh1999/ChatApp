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
            completed(Constant.MESSAGE_USERNAME_EXIST)
            return
        }
        
        if name.isEmpty {
            completed(Constant.MESSAGE_NAME_IS_EMPTY)
            return
        }
        
        if username.isEmpty {
            completed(Constant.MESSAGE_USERNAME_IS_EMPTY)
            return
        }
        
        if !username.isValidEmail {
            completed(Constant.MESSAGE_INVALID_USERNAME)
            return
        }
        
        if password.isEmpty {
            completed(Constant.MESSAGE_PASSWORD_IS_EMPTY)
            return
        }
        
        if password.count < 6 {
            completed(Constant.MESSAGE_INVALID_PASSWORD)
            return
        }
        
        if imgUrl.isEmpty {
            completed(Constant.MESSAGE_IMAGE_IS_EMPTY)
            return
        }
        
        completed(nil)
    }
    
    // MARK: Check change password data
    func checkChangePasswordData(_ user: User, _ currentPassword: String, _ newPassword: String, _ reEnterNewPassword: String, completed: (String?) -> Void) {
        if currentPassword.isEmpty {
            completed(Constant.MESSAGE_CURRENT_PASSWORD_IS_EMPTY)
            return
        }
        
        if currentPassword != user.password {
            completed(Constant.MESSAGE_INCORRECT)
            return
        }
        
        if newPassword.isEmpty {
            completed(Constant.MESSAGE_NEW_PASSWORD_IS_EMPTY)
            return
        }
        
        if reEnterNewPassword.isEmpty {
            completed(Constant.MESSAGE_RE_ENTER_PASSWORD_IS_EMPTY)
            return
        }
        
        if newPassword.count < 6 {
            completed(Constant.MESSAGE_INVALID_NEW_PASSWORD)
            return
        }
        
        if newPassword != reEnterNewPassword {
            completed(Constant.MESSAGE_COMPARE_FAILED)
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
            completed(Constant.MESSAGE_USERNAME_IS_EMPTY, userId)
            return
        }
        
        if users.contains(where: { user in
            user.username == username
        }) {
            completed(nil, userId)
            return
        }
        
        completed(Constant.MESSAGE_INVALID_USERNAME, userId)
    }
}
