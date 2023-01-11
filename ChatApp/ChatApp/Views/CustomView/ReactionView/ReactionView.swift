//
//  ReactionView.swift
//  ChatApp
//
//  Created by Nguyen Quang Huy on 17/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ReactionView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var reactButton: [UIButton]!
    @IBOutlet private weak var stackView: UIStackView!
    private let disposeBag = DisposeBag()
    
    var tapToButton: ((String) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Bundle.main.loadNibNamed("ReactionView", owner: self, options: nil)
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.stackView.layer.cornerRadius = 20
        
        for button in self.reactButton {
            button.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    guard let text = button.titleLabel?.text else { return }
                    self?.tapToButton?(text)
                })
                .disposed(by: self.disposeBag)
        }
    }
}
