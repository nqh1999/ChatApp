//
//  NavigationTitleView.swift
//  StaffManagementApp
//
//  Created by Nguyen Quang Huy on 02/11/2022.
//

import UIKit
import SDWebImage

class NavigationTitleView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet private weak var titleLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNavBarView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initNavBarView()
    }
    
    func initNavBarView() {
        Bundle.main.loadNibNamed("NavigationTitleView", owner: self, options: nil)
        self.addSubview(contentView)
        self.contentView.frame = self.frame
        img.layer.cornerRadius = img.layer.frame.width / 3
        img.contentMode = .scaleToFill
    }
    
    func setTitle(data: UserDetail?) {
        guard let data = data else { return }
        img.sd_setImage(with: URL(string: data.imgUrl))
        self.titleLbl.text = data.name
    }
}


