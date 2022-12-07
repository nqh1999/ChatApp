//
//  BaseTextField.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

class BaseTextField: UITextField {
    
    var shouldReturn: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.delegate = self
    }
}

extension BaseTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.shouldReturn?()
        return true
    }
}
