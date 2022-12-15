//
//  ChangePasswordViewController.swift
//  ChatApp
//
//  Created by BeeTech on 14/12/2022.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet private weak var currentPasswordTf: BaseTextField!
    @IBOutlet private weak var newPasswordTf: BaseTextField!
    @IBOutlet private weak var reEnterNewPasswordTf: BaseTextField!
    @IBOutlet private weak var messageView: MessageView!
    lazy private var presenter = ChangePasswordPresenter(view: self)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        self.navigationItem.titleView = nil
        self.title = "Change Password"
        self.setBackButton()
        self.currentPasswordTf.shouldReturn = { [weak self] in
            self?.newPasswordTf.becomeFirstResponder()
        }
        self.newPasswordTf.shouldReturn = { [weak self] in
            self?.reEnterNewPasswordTf.becomeFirstResponder()
        }
        self.reEnterNewPasswordTf.shouldReturn = { [weak self] in
            self?.reEnterNewPasswordTf.resignFirstResponder()
            self?.changePassword()
        }
        self.messageView.isHidden = true
    }
    
    func getPresenter() -> ChangePasswordPresenter {
        return self.presenter
    }
    
    private func changePassword() {
        self.presenter.changePassword(self.currentPasswordTf.text ?? "", self.newPasswordTf.text ?? "", self.reEnterNewPasswordTf.text ?? "")
    }
    
    @IBAction private func changePassword(_ sender: Any) {
        self.changePassword()
    }
    
    @IBAction private func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChangePasswordViewController: ChangePasswordProtocol {
    func didGetChangePasswordResult(result: String?) {
        self.messageView.isHidden = false
        if let result = result {
            self.messageView.showMessage(result)
        } else {
            self.messageView.showMessage(Err.changePasswordSuccess.rawValue)
            self.messageView.confirm = { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
