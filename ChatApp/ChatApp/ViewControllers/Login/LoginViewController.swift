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
    func didGetLoginResult(result: Bool, userId: Int) {
        if result {
            let vc = ListViewController()
            vc.presenter.setCurrentId(id: userId)
            (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
        } else {
            print("Login failed")
        }
    }
}
