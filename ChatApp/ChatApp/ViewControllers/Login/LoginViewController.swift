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
    lazy private var presenter = LoginPresenter(view: self)
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    private func setupUI() {
        self.loginButton.layer.cornerRadius = 5
        self.userNameLabel.becomeFirstResponder()
        self.userNameLabel.shouldReturn = { [weak self] in
            self?.passwordLabel.becomeFirstResponder()
        }
        self.passwordLabel.shouldReturn = { [weak self] in
            self?.login()
        }
    }
    private func setupData() {
        self.presenter.fetchUser()
    }
    private func login() {
        self.view.endEditing(true)
        self.presenter.checkLogin(username: self.userNameLabel.text ?? "", password: self.passwordLabel.text ?? "")
    }
    @IBAction private func checkLogin(_ sender: Any) {
        self.login()
    }
}
extension LoginViewController: LoginProtocol {
    func didGetLoginResult(result: Bool, userId: Int) {
        if result {
            print("Login success")
            let vc = ListViewController()
            vc.getPresenter().setCurrentId(id: userId)
            (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
        } else {
            print("Login failed")
        }
    }
}
