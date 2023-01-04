//
//  LoginViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var loginButton: CustomButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var userNameTf: BaseTextField!
    @IBOutlet private weak var passwordTf: PasswordTextField!
    @IBOutlet private weak var messageView: MessageView!
    @IBOutlet private weak var loginFBButton: UIButton!
    lazy private var presenter = LoginPresenter(view: self)
    lazy private var disposeBag = DisposeBag()
    
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
        self.presenter.checkLogin(self.userNameTf.text ?? "", self.passwordTf.getPass())
    }
    
    // MARK: - UI Handler Methods
    private func setupUI() {
        self.userNameTf.text = "1@1.com"
        self.passwordTf.text = "123456"
        self.userNameTf.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .subscribe { [weak self] _ in
                self?.passwordTf.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        
        self.passwordTf.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .subscribe { [weak self] _ in
                self?.login()
            }
            .disposed(by: disposeBag)
        
        self.showPasswordButton.layer.cornerRadius = 1
        self.showPasswordButton.layer.borderWidth = 1
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
    
    @IBAction private func loginWithFacebook(_ sender: Any) {
        self.presenter.facebookLogin(self)
    }
    
    @IBAction private func loginWithGoogle(_ sender: Any) {
        self.presenter.googleLogin(self)
    }
    
    @IBAction private func loginWithZalo(_ sender: Any) {
        self.presenter.zaloLogin(self)
    }
}

// MARK: - Extension

extension LoginViewController: LoginProtocol {
    func didGetLoginResult(result: Bool, senderId: String) {
        self.messageView.isHidden = false
        if !result {
            self.messageView.showMessage(Constant.MESSAGE_LOGIN_FAILED)
        } else {
            self.messageView.showMessage(Constant.MESSAGE_LOGIN_SUCCESS)
            self.messageView.confirm = { [weak self] _ in
                self?.presenter.setState(senderId)
                let tabBar = UITabBarController()
                let listNav = UINavigationController(rootViewController: ListViewController(senderId))
                let settingNav = UINavigationController(rootViewController: SettingViewController(senderId))
                listNav.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message.fill"), tag: 0)
                settingNav.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "person.circle.fill"), tag: 1)
                tabBar.setViewControllers([listNav, settingNav], animated: false)
                tabBar.tabBar.tintColor = .blue
                tabBar.tabBar.unselectedItemTintColor = .gray
                (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController =
                tabBar
            }
        }
    }
}
