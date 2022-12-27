//
//  BaseTextField.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

class BaseTextField: UITextField {
    @IBInspectable private var leftImage: UIImage? {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable private var leftPadding: CGFloat = 0
    @IBInspectable private var color: UIColor = UIColor.lightGray {
        didSet {
            self.updateView()
        }
    }
    var shouldReturn: (() -> Void)?
    
    func updateView() {
        if let image = leftImage {
            self.leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            self.leftView = imageView
        } else {
            self.leftViewMode = UITextField.ViewMode.never
            self.leftView = nil
        }
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.25
        self.delegate = self
        self.font = UIFont(name: "futura-medium", size: 17)
        self.addDoneButtonOnKeyboard()
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }

    @objc private func doneButtonAction() {
        self.resignFirstResponder()
    }
}

extension BaseTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.shouldReturn?()
        return true
    }
}
