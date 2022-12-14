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
    @IBOutlet private weak var passwordTf: BaseTextField!
    @IBOutlet private weak var chooseImgButton: UIButton!
    @IBOutlet private weak var backToLoginButton: UIButton!
    @IBOutlet private weak var registerButton: CustomButton!
    @IBOutlet private weak var avt: UIImageView!
    @IBOutlet private weak var messageView: MessageView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    private var imgPickerView = UIImagePickerController()
    lazy private var presenter = RegisterPresenter(view: self)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    // MARK: - Data Handler Methods
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) { [weak self] in
            self?.presenter.fetchUser()
        }
    }
    
    private func sendRegisterData() {
        self.presenter.register(self.nameTf.text ?? "", self.usernameTf.text ?? "", self.passwordTf.text ?? "")
    }
    
    private func setImage(_ img: UIImage) {
        self.presenter.setImgUrl(img)
    }
    
    // MARK: - UI Handler Methods
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.chooseImgButton.layer.cornerRadius = 5
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
        self.messageView.isHidden = true
        self.avt.layer.borderWidth = 1
    }
    
    private func setupPickerView() {
        self.imgPickerView.delegate = self
        self.imgPickerView.sourceType = .photoLibrary
        self.imgPickerView.allowsEditing = true
        self.present(self.imgPickerView, animated: true)
    }
    
    // MARK: - Button Action
    @IBAction private func chooseImage(_ sender: Any) {
        self.view.endEditing(true)
        self.setupPickerView()
    }
    
    @IBAction private func register(_ sender: Any) {
        self.sendRegisterData()
    }
    
    @IBAction private func backToLogin(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Extension
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.editedImage] as? UIImage {
            self.setImage(img)
        } else if let img = info[.originalImage] as? UIImage {
            self.setImage(img)
        }
        self.imgPickerView.dismiss(animated: true)
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
}

extension RegisterViewController: RegisterProtocol {
    func didGetRegisterResult(result: String?) {
        self.messageView.isHidden = false
        if let result = result {
            self.messageView.showMessage(result)
        } else {
            self.messageView.showMessage(Constant.MESSAGE_REGISTER_SUCCESS)
            self.messageView.confirm = { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func didGetSetImageResult(_ img: UIImage) {
        self.avt.image = img
        self.spinner.stopAnimating()
    }
}

