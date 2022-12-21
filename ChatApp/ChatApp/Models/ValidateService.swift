//
//  ValidateService.swift
//  ChatApp
//
//  Created by BeeTech on 15/12/2022.
//

import Foundation

class ValidateService {

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
        if name.isEmpty {
            completed(Error.nameIsEmpty)
            return
        }
        
        if username.isEmpty {
            completed(Error.usernameIsEmpty)
            return
        }
        
        if password.isEmpty {
            completed(Error.passwordIsEmpty)
            return
        }
        
        if imgUrl.isEmpty {
            completed(Error.imgIsEmpty)
            return
        }
        
        if !username.isValidEmail {
            completed(Error.invalidUsername)
            return
        }
        
        if password.count < 6 {
            completed(Error.invalidPassword)
            return
        }
        
        if users.contains(where: { user in
            user.username == username
        }) {
            completed(Error.usernameExist)
        } else {
            completed(nil)
        }
    }
    
    // MARK: Check change password data
    func checkChangePasswordData(_ user: User, _ currentPassword: String, _ newPassword: String, _ reEnterNewPassword: String, completed: (String?) -> Void) {
        if currentPassword.isEmpty {
            completed(Error.currentPasswordIsEmpty)
            return
        }
        
        if currentPassword != user.password {
            completed(Error.passwordIncorrect)
            return
        }
        
        if newPassword.isEmpty {
            completed(Error.newPasswordIsEmpty)
            return
        }
        
        if reEnterNewPassword.isEmpty {
            completed(Error.reEnterNewPasswordIsEmpty)
            return
        }
        
        if newPassword.count < 6 {
            completed(Error.invalidPassword)
            return
        }
        
        if newPassword != reEnterNewPassword {
            completed(Error.passwordNotSame)
            return
        }
        
        completed(nil)
        
    }
    
    // MARK: Check username
    func checkUsername(_ users: [User], _ username: String, completed: (String?, String) -> Void) {
        var userId: String = ""
        users.forEach { user in
            if user.username == username {
                userId = user.id
            }
        }
        
        if username.isEmpty {
            completed(Error.usernameIsEmpty, userId)
        } else {
            if users.contains(where: { user in
                user.username == username
            }) {
                completed(nil, userId)
            } else {
                completed(Error.invalidUsername, userId)
            }
        }
    }
}
