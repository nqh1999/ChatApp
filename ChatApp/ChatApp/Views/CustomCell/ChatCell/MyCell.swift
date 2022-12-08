//
//  MyCell.swift
//  ChatApp
//
//  Created by BeeTech on 08/12/2022.
//

import UIKit

class MyCell: UITableViewCell {
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupData(data: Message) {
        if !data.text.isEmpty {
            self.messageLabel.text = data.text
        }
        if !data.img.isEmpty {
            self.imgView.sd_setImage(with: URL(string: data.img))
        }
    }
}
