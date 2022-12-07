//
//  LoginViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

final class LoginViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var userNameLabel: BaseTextField!
    @IBOutlet private weak var passwordLabel: BaseTextField!
    lazy var presenter = LoginPresenter(view: self)
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        userNameLabel.becomeFirstResponder()
        userNameLabel.shouldReturn = { [weak self] in
            self?.passwordLabel.becomeFirstResponder()
        }
        passwordLabel.shouldReturn = { [weak self] in
            self?.login()
        }
        presenter.fetchUser()
    }
    
    private func login() {
        view.endEditing(true)
        presenter.checkLogin(username: userNameLabel.text ?? "", password: passwordLabel.text ?? "")
        
    }
    
    @IBAction private func checkLogin(_ sender: Any) {
        self.login()
    }
}

extension LoginViewController: LoginProtocol {
    func didGetLoginResult(result: Bool) {
        if result {
            print("Login Success")
            self.navigationController?.pushViewController(ListViewController(), animated: true)
        } else {
            print("Login failed")
        }
    }
}

url
