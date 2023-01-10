//
//  ChangePasswordViewController.swift
//  ChatApp
//
//  Created by BeeTech on 14/12/2022.
//

import UIKit

final class ChangePasswordViewController: BaseViewController {
    
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
    
    convenience init(_ user: User?) {
        self.init()
        self.presenter.setUser(user)
    }
    
    // MARK: - UI Handler Methods
    private func setupUI() {
        self.navigationItem.titleView = nil
        self.title = "Change Password"
        self.setBackButton()
//        self.currentPasswordTf.shouldReturn = { [weak self] in
//            self?.newPasswordTf.becomeFirstResponder()
//        }
//        self.newPasswordTf.shouldReturn = { [weak self] in
//            self?.reEnterNewPasswordTf.becomeFirstResponder()
//        }
//        self.reEnterNewPasswordTf.shouldReturn = { [weak self] in
//            self?.reEnterNewPasswordTf.resignFirstResponder()
//            self?.sendChangePasswordData()
//        }
        self.messageView.isHidden = true
    }
    
    // MARK: - Data Handler Methods
    private func sendChangePasswordData() {
        self.presenter.handlerData(self.currentPasswordTf.text ?? "", self.newPasswordTf.text ?? "", self.reEnterNewPasswordTf.text ?? "")
    }
    
    // MARK: - Button Action
    @IBAction private func changePassword(_ sender: Any) {
        self.sendChangePasswordData()
    }
    
    @IBAction private func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extension
extension ChangePasswordViewController: ChangePasswordProtocol {
    func didGetChangePasswordResult(result: String?) {
        self.messageView.isHidden = false
        if let result = result {
            self.messageView.showMessage(result)
        } else {
            self.messageView.showMessage(Constant.MESSAGE_CHANGE_PASSWORD_SUCCESS)
            self.messageView.confirm = { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
