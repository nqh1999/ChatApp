//
//  ReactionView.swift
//  ChatApp
//
//  Created by Nguyen Quang Huy on 17/12/2022.
//

import UIKit

class ReactionView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var reactButton: [UIButton]!
    @IBOutlet private weak var stackView: UIStackView!
    
    var tapToButton: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Bundle.main.loadNibNamed("ReactionView", owner: self, options: nil)
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.stackView.layer.cornerRadius = 20
    }
    
    @IBAction private func reactButtonTapped(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        self.tapToButton?(text)
    }
}
