//
//  LoginViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var userNameTf: BaseTextField!
    @IBOutlet private weak var passwordTf: PasswordTextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    lazy private var presenter = LoginPresenter(view: self)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    // MARK: - Methods
    private func setupUI() {
        self.view.layer.contents = UIImage(named: "bgrLogin")?.cgImage
        self.userNameTf.text = "1@1.com"
        self.passwordTf.text = "123456"
        self.loginButton.layer.cornerRadius = 5
        self.userNameTf.shouldReturn = { [weak self] in
            self?.passwordTf.becomeFirstResponder()
        }
        self.passwordTf.shouldReturn = { [weak self] in
            self?.login()
        }
        self.showPasswordButton.layer.cornerRadius = 2
        self.passwordTf.setPass()
    }
    
    private func setupData() {
        self.presenter.fetchUser()
    }
    
    private func login() {
        self.view.endEditing(true)
        self.presenter.checkLogin(username: self.userNameTf.text ?? "", password: self.passwordTf.getPass())
    }
    
    @IBAction private func checkLogin(_ sender: Any) {
        self.login()
    }
    
    @IBAction func showPassword(_ sender: Any) {
        self.passwordTf.setState(isShow: !self.passwordTf.getState())
        let img = self.passwordTf.getState() ? UIImage(systemName: "checkmark") : UIImage()
        self.showPasswordButton.setImage(img, for: .normal)
        self.passwordTf.setText()
    }
}

extension LoginViewController: LoginProtocol {
    func didGetLoginResult(result: Bool, sender: User?, receivers: [User]) {
        if !result {
            self.showAler(text: "username or password is incorrect")
        } else {
            guard let sender = sender else { return }
            let vc = ListViewController()
            vc.getPresenter().setData(sender: sender, receivers: receivers)
            (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
        }
    }
}
