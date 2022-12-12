//
//  MessageCell.swift
//  ChatApp
//
//  Created by BeeTech on 09/12/2022.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet weak var timeSend: UILabel!
    @IBOutlet private weak var messageLabel: CustomLabel!
    @IBOutlet weak var timeReceive: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageLabel.layer.masksToBounds = true
        self.messageLabel.layer.cornerRadius = 6
        self.messageLabel.layer.borderWidth = 0.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupData(_ message: Message) {
        self.messageLabel.text = message.text
        self.timeSend.text = self.setTimestamp(epochTime: message.time)
        self.timeReceive.text = self.setTimestamp(epochTime: message.time)
    }
    func setupSentMessage() {
        self.messageLabel.backgroundColor = UIColor(named: "lightGreen")
        self.stackView.alignment = .trailing
    }
    func setupReceivedMessage() {
        self.messageLabel.backgroundColor = .white
        self.stackView.alignment = .leading
    }
}
