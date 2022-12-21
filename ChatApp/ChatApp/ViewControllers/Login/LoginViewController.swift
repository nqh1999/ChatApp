//
//  LoginViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit
import FacebookLogin

class LoginViewController: BaseViewController {

    
    
    // MARK: - Properties
    @IBOutlet private weak var loginButton: CustomButton!
    @IBOutlet private weak var registerButton: CustomButton!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var userNameTf: BaseTextField!
    @IBOutlet private weak var passwordTf: PasswordTextField!
    @IBOutlet private weak var messageView: MessageView!
    @IBOutlet private weak var loginFBButton: UIButton!
    lazy private var presenter = LoginPresenter(view: self)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
//        self.loginFBButton.delegate = self
        if let token = AccessToken.current, !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        } else {
//            self.loginFBButton.permissions = ["public_profile", "email"]
        }
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
    
    private func showListView(_ id: String) {
        self.messageView.showMessage(Error.loginSuccess)
        self.messageView.confirm = { [weak self] _ in
            self?.presenter.setState(id)
            (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController = UINavigationController(rootViewController: ListViewController(id))
        }
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
        let mm = LoginManager()
        mm.logIn(permissions: ["public_profile", "email"], viewController: self, completion: { result in
            print("FBSDK: == \(result)")
        })
    }
    
    @IBAction private func loginWithInstagram(_ sender: Any) {
        print("loginWithInstagram")
    }
    
    @IBAction private func loginWithZalo(_ sender: Any) {
        print("loginWithZalo")
    }
    
}

// MARK: - Extension

extension LoginViewController {
//    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
//        print("User Logged In")
//        if ((error) != nil)
//        {
//            // Process error
//        }
//        else if result.isCancelled {
//            // Handle cancellations
//        }
//        else {
//            // If you ask for multiple permissions at once, you
//            // should check if specific permissions missing
//            if result.grantedPermissions.contains("public_profile")
//            {
//                // Do work
//            }
//        }
//    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
        print("User Logged Out")
    }
    
    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool{
        return true
    }
}
extension LoginViewController: LoginProtocol {
    func didGetLoginResult(result: Bool, senderId: String) {
        self.messageView.isHidden = false
        if !result {
            self.messageView.showMessage(Error.loginFailed)
        } else {
            self.showListView(senderId)
        }
    }
}
