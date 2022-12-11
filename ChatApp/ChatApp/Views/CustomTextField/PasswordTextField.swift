//
//  PasswordTextField.swift
//  ChatApp
//
//  Created by Nguyen Quang Huy on 11/12/2022.
//

import UIKit

class PasswordTextField: BaseTextField {
    
    private var isShow: Bool = false
    private var hidePass: String = ""
    private var pass: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.25
        self.delegate = self
    }
    
    func setState(isShow: Bool) {
        self.isShow = isShow
    }
    
    func getState() -> Bool {
        return self.isShow
    }
    
    func setPass() {
        self.pass = self.text ?? ""
        self.setText()
    }
    
    func getPass() -> String {
        return self.pass
    }
    
    func setText() {
        self.hidePass = String(repeating: "*", count: pass.count)
        self.text = self.isShow ? self.pass : self.hidePass
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.isEmpty {
            self.pass = ""
        }
        if range.length == 0 {
            self.setText()
            self.pass += string
        } else {
            if pass.count >= range.length {
                self.pass.removeLast(range.length)
            } else {
                self.pass = ""
            }
            self.hidePass = String(repeating: "*", count: pass.count)
        }
        return true
    }
}
