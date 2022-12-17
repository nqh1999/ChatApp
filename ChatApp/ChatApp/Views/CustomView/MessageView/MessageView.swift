//
//  MessageView.swift
//  ChatApp
//
//  Created by BeeTech on 15/12/2022.
//

import UIKit

class MessageView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var messageTf: BaseTextField!
    @IBOutlet private weak var confirmButton: CustomButton!
    @IBOutlet private weak var cancelButton: CustomButton!
    @IBOutlet private weak var containerView: UIView!
    
    var confirm: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initView()
    }
    
    private func initView() {
        Bundle.main.loadNibNamed("MessageView", owner: self, options: nil)
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.messageTf.isHidden = true
        self.cancelButton.isHidden = true
        self.contentView.layer.borderWidth = 1
        
    }
    
    @IBAction private func confirm(_ sender: Any) {
        self.confirm?(self.messageTf.text ?? "")
        self.isHidden = true
    }
    
    @IBAction private func cancel(_ sender: Any) {
        self.messageTf.text = ""
        self.messageLabel.text = ""
        self.isHidden = true
    }
    
    func showMessage(_ message: String) {
        self.messageLabel.text = message
    }
    
    func showDeleteMessage(_ message: String) {
        self.cancelButton.isHidden = false
        self.messageLabel.text = message
    }
    
    func showChangeNameMessage(completed: @escaping (String) -> Void) {
        self.messageTf.isHidden = false
        self.cancelButton.isHidden = false
        self.messageLabel.text = "Change name"
        self.messageTf.shouldReturn = { [weak self] in
            completed(self?.messageTf.text ?? "")
            self?.messageTf.text = ""
        }
    }
    
}
