//
//  ChangePasswordViewController.swift
//  ChatApp
//
//  Created by BeeTech on 14/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

final class ChangePasswordViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var currentPasswordTf: BaseTextField!
    @IBOutlet private weak var newPasswordTf: BaseTextField!
    @IBOutlet private weak var reEnterNewPasswordTf: BaseTextField!
    @IBOutlet private weak var messageView: MessageView!
    @IBOutlet private weak var changePasswordButton: CustomButton!
    @IBOutlet private weak var cancelButton: UIButton!
    lazy private var presenter = ChangePasswordPresenter(view: self)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    convenience init(_ user: User?) {
        self.init()
        self.presenter.setUser(user)
    }
    
    // MARK: - UI Handler Methods
    override func setupUI() {
        super.setupUI()
        self.navigationItem.titleView = nil
        self.title = "Change Password"
        self.setBackButton()
        self.messageView.isHidden = true
        self.setupTextField()
        self.setupButton()
    }
    
    // MARK: Setup Textfield Event
    private func setupTextField() {
        self.currentPasswordTf.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] _ in
            self?.newPasswordTf.becomeFirstResponder()
        })
        .disposed(by: self.disposeBag)
        
        self.newPasswordTf.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] _ in
            self?.reEnterNewPasswordTf.becomeFirstResponder()
        })
        .disposed(by: self.disposeBag)
        
        self.reEnterNewPasswordTf.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] _ in
            self?.reEnterNewPasswordTf.resignFirstResponder()
            self?.sendChangePasswordData()
        })
        .disposed(by: self.disposeBag)
    }
    
    // MARK: - Data Handler Methods
    private func sendChangePasswordData() {
        self.presenter.handlerData(self.currentPasswordTf.text ?? "", self.newPasswordTf.text ?? "", self.reEnterNewPasswordTf.text ?? "")
    }
    
    // MARK: Setup Button Action
    private func setupButton() {
        self.changePasswordButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.sendChangePasswordData()
        })
        .disposed(by: self.disposeBag)
        
        self.cancelButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        .disposed(by: self.disposeBag)
    }
}

// MARK: - Extension
extension ChangePasswordViewController: ChangePasswordProtocol {
    func didGetChangePasswordResult(result: String?) {
        self.messageView.isHidden = false
        if let result = result {
            self.messageView.showMessage(result)
        } else {
            self.messageView.showMessage(L10n.changePasswordSuccess)
            self.messageView.confirm = { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
