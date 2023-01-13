//
//  CustomTextView.swift
//  ChatApp
//
//  Created by BeeTech on 27/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class CustomTextView: UITextView {
    
    private let disposeBag = DisposeBag()
    var textViewDidChange: ((String?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.25
        self.font = UIFont(name: "futura-medium", size: 17)
        self.addDoneButtonOnKeyboard()
        self.rx.didChange.subscribe(onNext: { [weak self] _ in
            self?.textViewDidChange?(self?.text)
        })
        .disposed(by: self.disposeBag)
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

