//
//  CustomButton.swift
//  ChatApp
//
//  Created by BeeTech on 14/12/2022.
//

import UIKit

class CustomButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.textAlignment = .center
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
}
