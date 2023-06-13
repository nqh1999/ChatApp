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
    
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchUser()
    }
    
    override func setupUI() {
        super.setupUI()
        self.navigationController?.navigationBar.isHidden = true
        self.userNameTf.text = Constant.defaultEmail
        self.passwordTf.text = Constant.defaultPassword
        self.passwordTf.setPass()
        self.loginZaloButton.setImage(Asset.zalo.image.withRenderingMode(.alwaysOriginal), for: .normal)
        self.loginGoogleButton.setImage(Asset.google.image.withRenderingMode(.alwaysOriginal), for: .normal)
        self.loginFBButton.setImage(Asset.facebook.image.withRenderingMode(.alwaysOriginal), for: .normal)
        self.showPasswordButton.layer.cornerRadius = 1
        self.showPasswordButton.layer.borderWidth = 1
    }
    
    override func setupRx() {
        self.viewModel.isLoginSuccess.withUnretained(self)
            .bind { owner, isLogin in
                guard isLogin else {
                    ToastUtil.show(L10n.loginFailed)
                    return
                }
                ToastUtil.show(L10n.loginSuccess)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    owner.viewModel.setState()
                    owner.createTabBar()
                }
            }.disposed(by: disposeBag)
        
        self.userNameTf.rx.controlEvent(.editingDidEndOnExit).withUnretained(self)
            .subscribe { owner, _ in
                owner.passwordTf.becomeFirstResponder()
            }.disposed(by: self.disposeBag)
        
        self.passwordTf.rx.controlEvent(.editingDidEndOnExit).withUnretained(self)
            .subscribe { owner, _ in
                owner.login()
            }.disposed(by: self.disposeBag)
    }
    
    override func setupTap() {
        self.loginButton.rx.tap.withUnretained(self)
            .bind { owner, _ in
                owner.login()
            }.disposed(by: self.disposeBag)
        
        self.registerButton.rx.tap.withUnretained(self)
            .bind { owner, _ in
                let vc = RegisterViewController()
                owner.push(vc)
            }.disposed(by: self.disposeBag)
        
        self.forgotPasswordButton.rx.tap.withUnretained(self)
            .bind { owner, _ in
                let vc = ForgotPasswordViewController()
                owner.push(vc)
            }.disposed(by: self.disposeBag)
        
        self.loginFBButton.rx.tap.withUnretained(self)
            .bind { owner, _ in
                owner.loginWithFacebook()
            }.disposed(by: self.disposeBag)
        
        self.loginZaloButton.rx.tap.withUnretained(self)
            .bind { owner, _ in
                owner.loginWithZalo()
            }.disposed(by: self.disposeBag)
        
        self.loginGoogleButton.rx.tap.withUnretained(self)
            .bind { owner, _ in
                owner.loginWithGoogle()
            }.disposed(by: self.disposeBag)
        
        self.showPasswordButton.rx.tap.withUnretained(self)
            .bind { owner, _ in
                let state = owner.passwordTf.getState()
                owner.passwordTf.setState(isShow: !state)
                let img = state ? UIImage(systemName: "checkmark") : UIImage()
                owner.showPasswordButton.setImage(img, for: .normal)
            }.disposed(by: self.disposeBag)
    }
    
    private func login() {
        self.view.endEditing(true)
        self.viewModel.checkLogin(self.userNameTf.text, self.passwordTf.getPass())
    }
}

// MARK: - Extension
extension LoginViewController {
    // MARK: - Login Social
    private func loginWithGoogle() {
        GoogleService.shared.login(self).subscribe(onNext: { [weak self] name, id, url in
            self?.viewModel.socialRegister(name, id, url)
        }).disposed(by: self.disposeBag)
    }
    
    private func loginWithZalo() {
        ZaloService.shared.login(self).subscribe(onNext: { [weak self] name, id, url in
            self?.viewModel.socialRegister(name, id, url)
        }).disposed(by: self.disposeBag)
    }
    
    private func loginWithFacebook() {
        FacebookService.shared.login(self).subscribe(onNext: { [weak self] name, id, url in
            self?.viewModel.socialRegister(name, id, url)
        }).disposed(by: self.disposeBag)
    }
}
