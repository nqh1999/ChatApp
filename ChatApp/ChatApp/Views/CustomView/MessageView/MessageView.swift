//
//  MessageView.swift
//  ChatApp
//
//  Created by BeeTech on 15/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MessageView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var messageTf: BaseTextField!
    @IBOutlet private weak var confirmButton: CustomButton!
    @IBOutlet private weak var cancelButton: CustomButton!
    @IBOutlet private weak var containerView: UIView!
    
    private let disposeBag = DisposeBag()
    
    var confirm: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initView()
    }
    
    private func initView() {
        Bundle.main.loadNibNamed("MessageView", owner: self, options: nil)
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.messageTf.isHidden = true
        self.cancelButton.isHidden = true
        self.contentView.layer.borderWidth = 1
        self.setupButton()
    }
    
    func showMessage(_ message: String) {
        self.messageLabel.text = message
    }
    
    func showDeleteMessage(_ message: String) {
        self.cancelButton.isHidden = false
        self.messageLabel.text = message
    }
    
    func showChangeNameMessage(completed: @escaping (String) -> Void) {
        self.messageTf.isHidden = false
        self.cancelButton.isHidden = false
        self.messageLabel.text = "Change name"
        self.messageTf.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] _ in
            completed(self?.messageTf.text ?? "")
            self?.messageTf.text = ""
        })
        .disposed(by: self.disposeBag)
    }
    
    // MARK: Setup Button Event
    private func setupButton() {
        self.confirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.confirm?(self?.messageTf.text ?? "")
            self?.isHidden = true
        })
        .disposed(by: self.disposeBag)
        
        self.cancelButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.messageTf.text = ""
            self?.messageLabel.text = ""
            self?.isHidden = true
        })
        .disposed(by: self.disposeBag)
    }
}
