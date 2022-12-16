//
//  ValidateService.swift
//  ChatApp
//
//  Created by BeeTech on 15/12/2022.
//

import Foundation

class ValidateService {

    // MARK: Check login data
    func checkLogin(_ users: [User], _ username: String, _ password: String, completed: (Bool, Int) -> Void) {
        var result: Bool = false
        var senderId: Int = 0
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
            completed(Err.nameIsEmpty.rawValue)
            return
        }
        
        if username.isEmpty {
            completed(Err.usernameIsEmpty.rawValue)
            return
        }
        
        if password.isEmpty {
            completed(Err.passwordIsEmpty.rawValue)
            return
        }
        
        if imgUrl.isEmpty {
            completed(Err.imgIsEmpty.rawValue)
            return
        }
        
        if !username.isValidEmail {
            completed(Err.invalidUsername.rawValue)
            return
        }
        
        if password.count < 6 {
            completed(Err.invalidPassword.rawValue)
            return
        }
        
        if users.contains(where: { user in
            user.username == username
        }) {
            completed(Err.usernameExist.rawValue)
        } else {
            completed(nil)
        }
    }
    
    // MARK: Check change password data
    func checkChangePasswordData(_ user: User, _ currentPassword: String, _ newPassword: String, _ reEnterNewPassword: String, completed: (String?) -> Void) {
        if currentPassword.isEmpty {
            completed(Err.currentPasswordIsEmpty.rawValue)
            return
        }
        
        if currentPassword != user.password {
            completed(Err.passwordIncorrect.rawValue)
            return
        }
        
        if newPassword.isEmpty {
            completed(Err.newPasswordIsEmpty.rawValue)
            return
        }
        
        if reEnterNewPassword.isEmpty {
            completed(Err.reEnterNewPasswordIsEmpty.rawValue)
            return
        }
        
        if newPassword.count < 6 {
            completed(Err.invalidPassword.rawValue)
            return
        }
        
        if newPassword != reEnterNewPassword {
            completed(Err.passwordNotSame.rawValue)
            return
        }
        
        completed(nil)
        
    }
    
    // MARK: Check username
    func checkUsername(_ users: [User], _ username: String, completed: (String?, Int) -> Void) {
        var userId: Int = 0
        users.forEach { user in
            if user.username == username {
                userId = user.id
            }
        }
        if username.isEmpty {
            completed(Err.usernameIsEmpty.rawValue, userId)
        } else {
            if users.contains(where: { user in
                user.username == username
            }) {
                completed(nil, userId)
            } else {
                completed(Err.invalidUsername.rawValue, userId)
            }
        }
    }
}
