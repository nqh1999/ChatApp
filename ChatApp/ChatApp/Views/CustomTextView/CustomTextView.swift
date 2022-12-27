//
//  CustomTextView.swift
//  ChatApp
//
//  Created by BeeTech on 27/12/2022.
//

import UIKit

class CustomTextView: UITextView {
    var shouldReturn: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.25
        self.delegate = self
        self.font = UIFont(name: "futura-medium", size: 17)
        self.addDoneButtonOnKeyboard()
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
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

extension CustomTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.resignFirstResponder()
        }
        self.isScrollEnabled = !(self.contentSize.height <= 129)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.layoutSubviews()
    }
}

