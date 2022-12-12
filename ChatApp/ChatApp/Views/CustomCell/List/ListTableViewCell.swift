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
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderWidth = 1
        self.avt.layer.cornerRadius = avt.layer.frame.width / 2
        self.avt.layer.borderWidth = 0.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillData(user: User?, message: Message?) {
        guard let user = user else { return }
        self.timeLabel.isHidden = false
        self.avt.sd_setImage(with: URL(string: user.imgUrl))
        self.nameLabel.text = user.name
        if let message = message {
            if !message.text.isEmpty {
                self.messageLabel.text = message.senderId == user.id ? message.text : "you: \(message.text)"
            } else if !message.img.isEmpty {
                self.messageLabel.text = message.senderId == user.id ? "\(user.name) send a photo" : "you send a photo"
            }
            self.timeLabel.text = self.setTimestamp(epochTime: message.time)
            self.messageLabel.textColor = message.senderId == user.id ? UIColor.black: UIColor.gray
            self.timeLabel.textColor = message.senderId == user.id ? UIColor.black: UIColor.gray
        } else {
            self.messageLabel.text = "Tap to chat"
            self.messageLabel.textColor = UIColor.gray
            self.timeLabel.isHidden = true
        }
    }
}

extension UITableViewCell {
    func setTimestamp(epochTime: Double) -> String {
        let currentDate = Date()
        let epochDate = Date(timeIntervalSince1970: epochTime)
        let calendar = Calendar.current
        
        let currentDay = calendar.component(.day, from: currentDate)
        let currentWeek = calendar.component(.weekday, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        let epochDay = calendar.component(.day, from: epochDate)
        let epochMonth = calendar.component(.month, from: epochDate)
        let epochYear = calendar.component(.year, from: epochDate)
        let epochWeek = calendar.component(.weekday, from: epochDate)
        let epochHour = calendar.component(.hour, from: epochDate)
        let epochMinute = calendar.component(.minute, from: epochDate)

        if currentYear - epochYear < 1 {
            if currentWeek - epochWeek < 1 {
                if currentDay - epochDay < 1 {
                    return "\(epochHour):\(epochMinute)"
                } else {
                    return self.getDayOfWeekFromInt(weekDay: epochWeek)
                }
            } else {
                return self.getMonthNameFromInt(month: epochMonth) + " \(epochDay)"
            }
        } else {
            return "\(currentYear)"
        }
    }

    func getMonthNameFromInt(month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sept"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
    
    func getDayOfWeekFromInt(weekDay: Int) -> String {
        switch weekDay {
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        case 8:
            return "Sun"
        default:
            return ""
        }
    }
}
