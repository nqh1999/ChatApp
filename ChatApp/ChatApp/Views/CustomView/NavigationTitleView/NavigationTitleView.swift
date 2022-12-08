//
//  NavigationTitleView.swift
//  StaffManagementApp
//
//  Created by Nguyen Quang Huy on 02/11/2022.
//

import UIKit
import SDWebImage

final class NavigationTitleView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var img: UIImageView!
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
        self.img.layer.cornerRadius = img.layer.frame.width / 3
        self.img.contentMode = .scaleToFill
    }
    func setTitle(data: UserDetail?) {
        guard let data = data else { return }
        self.img.sd_setImage(with: URL(string: data.imgUrl))
        self.titleLbl.text = data.name
    }
}


