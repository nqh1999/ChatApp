//
//  LoginViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var loginButton: CustomButton!
    @IBOutlet private weak var registerButton: CustomButton!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var userNameTf: BaseTextField!
    @IBOutlet private weak var passwordTf: PasswordTextField!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var messageView: MessageView!
    lazy private var presenter = LoginPresenter(view: self)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
    }
    
    // MARK: - Data Handler Methods
    private func setupData() {
        self.presenter.fetchUser()
    }
    
    private func login() {
        self.view.endEditing(true)
        self.presenter.checkLogin(username: self.userNameTf.text ?? "", password: self.passwordTf.getPass())
    }
    
    // MARK: - UI Handler Methods
    private func setupUI() {
        self.view.layer.contents = UIImage(named: "bgrLogin")?.cgImage
        self.userNameTf.text = "1@1.com"
        self.passwordTf.text = "123456"
        self.userNameTf.shouldReturn = { [weak self] in
            self?.passwordTf.becomeFirstResponder()
        }
        self.passwordTf.shouldReturn = { [weak self] in
            self?.login()
        }
        self.showPasswordButton.layer.cornerRadius = 2
        self.passwordTf.setPass()
        self.messageView.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Button Action
    @IBAction private func checkLogin(_ sender: Any) {
        self.login()
    }
    
    @IBAction private func register(_ sender: Any) {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @IBAction private func goToForgotPasswordView(_ sender: Any) {
        self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }
    
    @IBAction private func showPassword(_ sender: Any) {
        self.passwordTf.setState(isShow: !self.passwordTf.getState())
        let img = self.passwordTf.getState() ? UIImage(systemName: "checkmark") : UIImage()
        self.showPasswordButton.setImage(img, for: .normal)
        self.passwordTf.setText()
    }
}

// MARK: - Extension
extension LoginViewController: LoginProtocol {
    func didGetLoginResult(result: Bool, senderId: Int) {
        self.messageView.isHidden = false
        if !result {
            self.messageView.showMessage(Err.loginFailed.rawValue)
        } else {
            self.messageView.showMessage(Err.loginSuccess.rawValue)
            self.presenter.setState(senderId)
            self.messageView.confirm = { _ in
                (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController = UINavigationController(rootViewController: ListViewController(senderId))
            }
        }
    }
}
