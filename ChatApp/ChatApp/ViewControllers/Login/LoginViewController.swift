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
    @IBOutlet private weak var loginFBButton: UIButton!
    @IBOutlet private weak var loginZaloButton: UIButton!
    @IBOutlet private weak var loginGoogleButton: UIButton!
    @IBOutlet private weak var userNameTf: BaseTextField!
    @IBOutlet private weak var passwordTf: PasswordTextField!
    
    lazy private var presenter = LoginPresenter(view: self)
    private var viewModel = LoginViewModel()
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
    }
    
    // MARK: Setup Data
    private func setupData() {
        self.presenter.fetchUser()
    }
    
    // MARK: Login
    private func login() {
        self.view.endEditing(true)
        self.presenter.checkLogin(self.userNameTf.text, self.passwordTf.getPass())
    }
    
    // MARK: Setup UI
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.setupButton()
        self.setupTextField()
    }
    
    // MARK: Setup TextField
    private func setupTextField() {
        self.userNameTf.text = "1@1.com"
        self.passwordTf.text = "123456"
        self.passwordTf.setPass()
        self.userNameTf.rx.controlEvent(.editingDidEndOnExit).subscribe { [weak self] _ in
            self?.passwordTf.becomeFirstResponder()
        }
        .disposed(by: self.disposeBag)
        
        self.passwordTf.rx.controlEvent(.editingDidEndOnExit).subscribe { [weak self] _ in
            self?.login()
        }
        .disposed(by: self.disposeBag)
    }
    
    // MARK: Setup Button
    private func setupButton() {
        self.loginZaloButton.setImage(Asset.zalo.image.withRenderingMode(.alwaysOriginal), for: .normal)
        self.loginGoogleButton.setImage(Asset.google.image.withRenderingMode(.alwaysOriginal), for: .normal)
        self.loginFBButton.setImage(Asset.facebook.image.withRenderingMode(.alwaysOriginal), for: .normal)
        self.showPasswordButton.layer.cornerRadius = 1
        self.showPasswordButton.layer.borderWidth = 1
        self.loginButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.login()
        })
        .disposed(by: self.disposeBag)
        
        self.registerButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.pushViewController(RegisterViewController(), animated: true)
        })
        .disposed(by: self.disposeBag)
        
        self.forgotPasswordButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
        })
        .disposed(by: self.disposeBag)
        
        self.loginFBButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let vc = self else { return }
            self?.presenter.facebookLogin(vc)
        })
        .disposed(by: self.disposeBag)
        
        self.loginZaloButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let vc = self else { return }
            self?.presenter.zaloLogin(vc)
        })
        .disposed(by: self.disposeBag)
        
        self.loginGoogleButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.loginWithGoogle()
        }).disposed(by: self.disposeBag)
        
        self.showPasswordButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let state = self?.passwordTf.getState() else { return }
            self?.passwordTf.setState(isShow: !state)
            let img = state ? UIImage(systemName: "checkmark") : UIImage()
            self?.showPasswordButton.setImage(img, for: .normal)
        })
        .disposed(by: self.disposeBag)
    }
    
    // MARK: - Login Social
    private func loginWithGoogle() {
        GoogleService.shared.login(self).subscribe(onNext: { [weak self] name, id, url in
            self?.viewModel.register(name, id, url)
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: Setup Tabbar
    private func createTabBar(_ senderId: String) {
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

// MARK: - Extension
extension LoginViewController: LoginProtocol {
    func didGetLoginResult(result: Bool, senderId: String) {
        if !result {
            ToastUtil.show(L10n.loginFailed)
        } else {
            ToastUtil.show(L10n.loginSuccess)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.presenter.setState(senderId)
                self.createTabBar(senderId)
            }
        }
    }
}
