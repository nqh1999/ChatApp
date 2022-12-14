//
//  ListTableViewCell.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit
import SDWebImage

class ListTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet private weak var avt: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var notifyButton: UIButton!
    @IBOutlet private weak var stateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.avt.layer.cornerRadius = avt.layer.frame.width / 2
        self.notifyButton.layer.cornerRadius = self.notifyButton.frame.width / 2
        self.stateButton.layer.cornerRadius = self.stateButton.frame.width / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillData(_ user: User?,_ message: Message?) {
        guard let user = user else { return }
        self.timeLabel.isHidden = false
        self.avt.sd_setImage(with: URL(string: user.imgUrl))
        self.stateButton.isHidden = !user.isActive
        self.nameLabel.text = user.name
        if let message = message {
            self.timeLabel.isHidden = false
            if !message.text.isEmpty {
                self.messageLabel.text = message.senderId == user.id ? message.text : "you: \(message.text)"
            } else if !message.img.isEmpty {
                self.messageLabel.text = message.senderId == user.id ? "\(user.name) sent a photo" : "you sent a photo"
            }
            self.timeLabel.text = self.setTimestamp(epochTime: message.time)
            if !message.read {
                self.messageLabel.textColor = message.senderId == user.id ? UIColor.black: UIColor.systemGray
                self.timeLabel.textColor = message.senderId == user.id ? UIColor.black: UIColor.systemGray
                self.notifyButton.isHidden = message.senderId == user.id ? false : true
            } else {
                self.notifyButton.isHidden = true
            }
        } else {
            self.messageLabel.text = "Tap to chat"
            self.messageLabel.textColor = UIColor.systemGray
            self.timeLabel.textColor = UIColor.systemGray
            self.timeLabel.isHidden = true
            self.notifyButton.isHidden = true
        }
    }
}
