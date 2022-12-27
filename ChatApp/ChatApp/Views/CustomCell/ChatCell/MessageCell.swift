//
//  MessageCell.swift
//  ChatApp
//
//  Created by BeeTech on 09/12/2022.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var timeSend: UILabel!
    @IBOutlet private weak var messageLabel: CustomLabel!
    @IBOutlet private weak var timeReceive: UILabel!
    @IBOutlet private weak var spaceView: UIView!
    @IBOutlet private weak var reactionLabel: CustomLabel!

    private var reaction: String = ""
    private var isSender: Bool = false
    
    var longPress: ((String) -> Void)?
    var doubleTapToMessage: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.messageLabel.layer.masksToBounds = true
        self.messageLabel.layer.cornerRadius = 10
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:))))
        self.addGestureRecognizer(doubleTap)
        self.reactionLabel.layer.cornerRadius = 7
        self.reactionLabel.layer.masksToBounds = true
        self.reactionLabel.layer.borderWidth = 1
        self.reactionLabel.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupData(_ message: Message, _ isSender: Bool) {
        self.reaction = message.reaction
        self.messageLabel.text = message.text
        self.timeSend.text = self.setTimestamp(epochTime: message.time)
        self.timeReceive.text = self.setTimestamp(epochTime: message.time)
        self.reactionLabel.text = message.reaction
        self.reactionLabel.isHidden = message.reaction.isEmpty
        self.spaceView.isHidden = self.reactionLabel.isHidden
        if message.text == "👍" {
            self.messageLabel.backgroundColor = .clear
            self.messageLabel.layer.borderWidth = 0
        } else {
            self.messageLabel.backgroundColor = isSender ? UIColor(named: "sendMessage") : UIColor(named: "receiveMessage")
            self.messageLabel.layer.borderWidth = 0.2
        }
        self.stackView.alignment = isSender ? .trailing : .leading
        self.messageLabel.textColor = isSender ? UIColor.white : UIColor.black
    }
    
    func setupSentMessage(_ message: Message) {
        self.isSender = true
        self.setupData(message, self.isSender)
        self.contentView.addConstraint(NSLayoutConstraint(item: self.reactionLabel!, attribute: .trailing, relatedBy: .equal, toItem: self.messageLabel, attribute: .trailing, multiplier: 1, constant: 0))
    }
    
    func setupReceivedMessage(_ message: Message) {
        self.isSender = false
        self.setupData(message, self.isSender)
        self.contentView.addConstraint(NSLayoutConstraint(item: self.reactionLabel!, attribute: .leading, relatedBy: .equal, toItem: self.messageLabel, attribute: .trailing, multiplier: 1, constant: -self.reactionLabel.frame.width))
    }
    
    // reaction message
    @objc private func longPress(_ gesture: UILongPressGestureRecognizer) {
        if isSender { return }
        self.longPress?(self.reaction)
    }
                                  
    @objc private func doubleTap() {
        if isSender { return }
        self.doubleTapToMessage?()
    }
}
