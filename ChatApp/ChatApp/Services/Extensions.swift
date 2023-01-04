//
//  Extension.swift
//  ChatApp
//
//  Created by Nguyen Quang Huy on 15/12/2022.
//

import UIKit

// MARK: - Extension String
extension String {
    var isValidEmail: Bool {
        let validEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let email = NSPredicate(format:"SELF MATCHES %@", validEmail)
        return email.evaluate(with: self)
    }
}

// MARK: - Extension Table View Cell
extension UITableViewCell {
    
    func setTimestamp(epochTime: Double) -> String {
        let currentDate = Date.now
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
            if currentWeek - epochWeek <= 1 {
                if currentDay - epochDay < 1 {
                    return epochMinute < 10 ? "\(epochHour):0\(epochMinute)" : "\(epochHour):\(epochMinute)"
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

    private func getMonthNameFromInt(month: Int) -> String {
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
    
    private func getDayOfWeekFromInt(weekDay: Int) -> String {
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
