//
//  ListTableViewCell.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit
import SDWebImage

class ListTableViewCell: UITableViewCell {
    @IBOutlet private weak var avt: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avt.layer.cornerRadius = avt.layer.frame.width / 2
        self.avt.layer.borderWidth = 0.5
        self.avt.contentMode = .scaleToFill
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func fillData(data: UserDetail?) {
        guard let data = data else { return }
        self.avt.sd_setImage(with: URL(string: data.imgUrl))
        self.nameLabel.text = data.name
        self.messageLabel.text = "Message"
    }
}
