//
//  FriendCell.swift
//  ChatApp
//
//  Created by BeeTech on 08/12/2022.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupData(data: Message) {
//        guard let data = data else { return }
        if !data.text.isEmpty {
            messageLabel.text = data.text
        }
        if !data.img.isEmpty {
            imgView.sd_setImage(with: URL(string: data.img))
        }
    }
}
