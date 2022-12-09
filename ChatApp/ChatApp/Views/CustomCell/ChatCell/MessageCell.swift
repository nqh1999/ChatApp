//
//  MessageCell.swift
//  ChatApp
//
//  Created by BeeTech on 09/12/2022.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var messageLabel: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageLabel.layer.masksToBounds = true
        self.messageLabel.layer.cornerRadius = 10
        self.messageLabel.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupData(text: String) {
        self.messageLabel.text = text
    }
    func setupSentMessage() {
        self.messageLabel.backgroundColor = UIColor(named: "lightGreen")
        self.stackView.alignment = .trailing
    }
    func setupReceivedMessage() {
        self.messageLabel.backgroundColor = UIColor(named: "lightYellow")
        self.stackView.alignment = .leading
    }
}
