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
        avt.layer.cornerRadius = avt.layer.frame.width / 2
        avt.layer.borderWidth = 0.5
        avt.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillData(data: UserDetail?) {
        guard let data = data else { return }
        avt.sd_setImage(with: URL(string: data.imgUrl))
        nameLabel.text = data.name
        messageLabel.text = "message"
    }
}
