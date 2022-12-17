//
//  ForgotPasswordViewController.swift
//  ChatApp
//
//  Created by BeeTech on 15/12/2022.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var usernameTf: BaseTextField!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var resetPasswordButton: CustomButton!
    @IBOutlet weak var messageView: MessageView!
    lazy private var presenter = ForgotPasswordPresenter(view: self)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    // MARK: - Data Handler Methods
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) { [weak self] in
            self?.presenter.fetchUser()
        }
    }
    
    private func resetPassword() {
        self.presenter.checkUsername(self.usernameTf.text ?? "")
    }
    
    // MARK: - UI Handler Methods
    private func setupUI() {
        self.view.layer.contents = UIImage(named: "bgrLogin")?.cgImage
        self.navigationController?.navigationBar.isHidden = true
        self.usernameTf.shouldReturn = { [weak self] in
            self?.usernameTf.resignFirstResponder()
            self?.resetPassword()
        }
        self.messageView.isHidden = true
    }

    // MARK: - Button Action
    @IBAction private func resetPassword(_ sender: Any) {
        self.resetPassword()
    }
    
    @IBAction private func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - Extension
extension ForgotPasswordViewController: ForgotPasswordProtocol {
    func didGetValidateUsernameResult(result: String?, newPass: String) {
        self.messageView.isHidden = false
        if let result = result {
            self.messageView.showMessage(result)
        } else {
            self.messageView.showMessage("New password is \(newPass)")
            self.messageView.confirm = { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
