//
//  ImgCell.swift
//  ChatApp
//
//  Created by BeeTech on 09/12/2022.
//

import UIKit
import SDWebImage

class ImgCell: UITableViewCell {
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupImg(_ message: Message) {
        self.imgView.sd_setImage(with: URL(string: message.img))
    
    }
    func setupSentImg() {
        self.stackView.alignment = .trailing
    }
    func setupReceivedImg() {
        self.stackView.alignment = .leading
    }
}
