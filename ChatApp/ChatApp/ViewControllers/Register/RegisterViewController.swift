//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by BeeTech on 12/12/2022.
//

import UIKit

final class RegisterViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet private weak var nameTf: BaseTextField!
    @IBOutlet private weak var usernameTf: BaseTextField!
    @IBOutlet private weak var avt: UIImageView!
    @IBOutlet private weak var chooseImgButton: UIButton!
    @IBOutlet private weak var backToLoginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var passwordTf: BaseTextField!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    lazy private var presenter = RegisterPresenter(view: self)
    private var imgPickerView = UIImagePickerController()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
    }
    
    // MARK: - Methods
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) {
            self.presenter.fetchUser()
        }
    }
    
    private func setupUI() {
        self.view.layer.contents = UIImage(named: "bgrLogin")?.cgImage
        self.navigationController?.navigationBar.isHidden = true
        self.chooseImgButton.layer.cornerRadius = 5
        self.registerButton.layer.cornerRadius = 5
        self.avt.layer.borderWidth = 1
        self.avt.layer.borderColor = UIColor.white.cgColor
        self.nameTf.shouldReturn = { [weak self] in
            self?.usernameTf.becomeFirstResponder()
        }
        self.usernameTf.shouldReturn = { [weak self] in
            self?.passwordTf.becomeFirstResponder()
        }
        self.passwordTf.shouldReturn = { [weak self] in
            self?.passwordTf.resignFirstResponder()
        }
        self.spinner.isHidden = true
    }
    
    private func setupPickerView() {
        self.imgPickerView.delegate = self
        self.imgPickerView.sourceType = .photoLibrary
        self.present(self.imgPickerView, animated: true)
    }
    
    @IBAction private func chooseImage(_ sender: Any) {
        self.view.endEditing(true)
        self.setupPickerView()
    }
    
    private func sendRegisterData() {
        self.presenter.register(self.nameTf.text ?? "", self.usernameTf.text ?? "", self.passwordTf.text ?? "")
    }
    
    
    @IBAction private func register(_ sender: Any) {
        self.sendRegisterData()
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.presenter.setImgUrl(img: img) {
            self.avt.image = img
            self.spinner.stopAnimating()
        }
        self.imgPickerView.dismiss(animated: true)
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
}

extension RegisterViewController: RegisterProtocol {
    func didGetRegisterResult(result: String?) {
        if let result = result {
            self.showAlert(text: result)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

