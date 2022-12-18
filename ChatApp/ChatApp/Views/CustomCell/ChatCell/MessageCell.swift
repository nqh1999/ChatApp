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

    private var senderReaction: String = ""
    private var receiverReaction: String = ""
    
    var longPress: ((String, String) -> Void)?
    var doubleTapToMessage: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.messageLabel.layer.masksToBounds = true
        self.messageLabel.layer.cornerRadius = 10
        self.messageLabel.layer.borderWidth = 0.2
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
    
    func setupData(_ message: Message) {
        self.senderReaction = message.senderReaction
        self.receiverReaction = message.receiverReaction
        self.messageLabel.text = message.text
        self.timeSend.text = self.setTimestamp(epochTime: message.time)
        self.timeReceive.text = self.setTimestamp(epochTime: message.time)
        self.reactionLabel.isHidden = message.senderReaction.isEmpty && message.receiverReaction.isEmpty
        self.spaceView.isHidden = self.reactionLabel.isHidden
        let text =  (!message.senderReaction.isEmpty && !message.receiverReaction.isEmpty) ? "2" : ""
        self.reactionLabel.text = (message.senderReaction == message.receiverReaction) ? message.senderReaction + text : message.senderReaction + message.receiverReaction + text
    }
    
    func setupSentMessage() {
        self.messageLabel.backgroundColor = UIColor(named: "lightGreen")
        self.stackView.alignment = .trailing
        self.contentView.addConstraint(NSLayoutConstraint(item: self.reactionLabel!, attribute: .trailing, relatedBy: .equal, toItem: self.messageLabel, attribute: .trailing, multiplier: 1, constant: 0))
    }
    
    func setupReceivedMessage() {
        self.messageLabel.backgroundColor = .white
        self.stackView.alignment = .leading
        self.contentView.addConstraint(NSLayoutConstraint(item: self.reactionLabel!, attribute: .leading, relatedBy: .equal, toItem: self.messageLabel, attribute: .leading, multiplier: 1, constant: 0))
    }
    
    // reaction message
    @objc private func longPress(_ gesture: UILongPressGestureRecognizer) {
        self.longPress?(self.senderReaction, self.receiverReaction)
    }
                                  
    @objc private func doubleTap() {
        self.doubleTapToMessage?()
    }
}
