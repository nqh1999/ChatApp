//
//  ListTableViewCell.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit
import SDWebImage

final class NavigationTitleView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var img: UIImageView!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet private weak var titleLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initNavBarView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initNavBarView()
    }
    
    private func initNavBarView() {
        Bundle.main.loadNibNamed("NavigationTitleView", owner: self, options: nil)
        self.addSubview(contentView)
        self.contentView.frame = self.frame
        self.img.layer.cornerRadius = img.layer.frame.width / 2
        self.titleLbl.text = ""
        self.stateButton.layer.cornerRadius = stateButton.layer.frame.width / 2
    }
    
    func setTitleView(data: User?) {
        guard let data = data else { return }
        self.img.sd_setImage(with: URL(string: data.imgUrl))
        self.titleLbl.text = data.name
        self.stateButton.isHidden = !data.isActive
    }
}


