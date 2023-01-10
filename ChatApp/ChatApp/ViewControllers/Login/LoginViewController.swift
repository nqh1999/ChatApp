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
    @IBOutlet private weak var loginZaloButton: UIButton!
    @IBOutlet private weak var loginGoogleButton: UIButton!
    
    lazy private var presenter = LoginPresenter(view: self)
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupButton()
        self.setupTextField()
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
        self.showPasswordButton.layer.cornerRadius = 1
        self.showPasswordButton.layer.borderWidth = 1
        self.passwordTf.setPass()
        self.messageView.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Setup TextField Event
    private func setupTextField() {
        self.userNameTf.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .subscribe { [weak self] _ in
                self?.passwordTf.becomeFirstResponder()
            }
            .disposed(by: self.disposeBag)
        
        self.passwordTf.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .subscribe { [weak self] _ in
                self?.login()
            }
            .disposed(by: self.disposeBag)
    }
    
    // MARK: Button Action
    private func setupButton() {
        self.loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.login()
            })
            .disposed(by: self.disposeBag)
        
        self.registerButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.pushViewController(RegisterViewController(), animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.forgotPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.loginFBButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let vc = self else { return }
                self?.presenter.facebookLogin(vc)
            })
            .disposed(by: self.disposeBag)
        
        self.loginZaloButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let vc = self else { return }
                self?.presenter.zaloLogin(vc)
            })
            .disposed(by: self.disposeBag)
        
        self.loginGoogleButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let vc = self else { return }
                self?.presenter.googleLogin(vc)
            })
            .disposed(by: self.disposeBag)
        
        self.showPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.passwordTf.setState(isShow: !self!.passwordTf.getState())
                let img = self!.passwordTf.getState() ? UIImage(systemName: "checkmark") : UIImage()
                self?.showPasswordButton.setImage(img, for: .normal)
            })
            .disposed(by: self.disposeBag)
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
        self.messageView.isHidden = false
        if !result {
            self.messageView.showMessage(Constant.MESSAGE_LOGIN_FAILED)
        } else {
            self.messageView.showMessage(Constant.MESSAGE_LOGIN_SUCCESS)
            self.messageView.confirm = { [weak self] _ in
                self?.presenter.setState(senderId)
                self?.createTabBar(senderId)
            }
        }
    }
}
