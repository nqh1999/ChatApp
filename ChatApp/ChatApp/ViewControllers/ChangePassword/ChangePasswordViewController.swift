//
//  ChangePasswordViewController.swift
//  ChatApp
//
//  Created by BeeTech on 14/12/2022.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    @IBOutlet weak var currentPasswordTf: BaseTextField!
    @IBOutlet weak var newPasswordTf: BaseTextField!
    @IBOutlet weak var reEnterNewPasswordTf: BaseTextField!
    
    lazy private var presenter = ChangePasswordPresenter(view: self)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
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
        if let result = result {
            self.showAlert(text: result) {}
        } else {
            self.showAlert(text: Err.changePasswordSuccess.rawValue) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
