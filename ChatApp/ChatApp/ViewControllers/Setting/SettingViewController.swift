//
//  SettingViewController.swift
//  ChatApp
//
//  Created by BeeTech on 14/12/2022.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var chooseImageButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var editProfileButton: CustomButton!
    @IBOutlet private weak var changePasswordButton: CustomButton!
    @IBOutlet private weak var logoutButton: CustomButton!
    @IBOutlet private weak var editName: UIButton!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var messageView: MessageView!
    lazy private var presenter = SettingPresenter(view: self)
    private var imgPickerView = UIImagePickerController()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
    }
    
    convenience init(_ id: String) {
        self.init()
        self.presenter.setUserId(id)
    }
    
    // MARK: - UI Handler Methods
    private func setupUI() {
        self.imgView.layer.cornerRadius = self.imgView.frame.width / 2
        self.imgView.layer.borderWidth = 2
        self.imgView.layer.borderColor = UIColor.black.cgColor
        self.spinner.isHidden = true
        self.navigationItem.titleView = nil
        self.title = "Setting"
        self.messageView.isHidden = true
    }
    
    private func setupPickerView() {
        self.imgPickerView.delegate = self
        self.imgPickerView.sourceType = .photoLibrary
        self.imgPickerView.allowsEditing = true
        self.present(self.imgPickerView, animated: true)
    }
    
    // MARK: - Data Handler Methods
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) { [weak self] in
            self?.presenter.fetchUser()
        }
    }
    
    private func changeName(_ name: String) {
        guard !name.isEmpty else { return }
        self.presenter.changeName(name)
        self.nameLabel.text = name
        self.messageView.isHidden = true
    }
    
    private func setImage(_ img: UIImage) {
        self.presenter.setImgUrl(img)
    }
    
    // MARK: - Button Action
    @IBAction func logout(_ sender: Any) {
        self.presenter.setState()
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
    
    @IBAction private func chooseImg(_ sender: Any) {
        self.setupPickerView()
    }
    
    @IBAction private func editName(_ sender: Any) {
        self.messageView.isHidden = false
        self.messageView.showChangeNameMessage { name in
            self.changeName(name)
        }
        self.messageView.confirm = { [weak self] name in
            self?.changeName(name)
        }
    }
    
    @IBAction private func goToEditProfileView(_ sender: Any) {
        
    }
    
    @IBAction private func goToChangePasswordView(_ sender: Any) {
        self.navigationController?.pushViewController(ChangePasswordViewController(self.presenter.getUser()), animated: true)
    }
}

// MARK: - Extention
extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension SettingViewController: SettingProtocol {
    func didGetSetImgResult(_ img: UIImage) {
        self.imgView.image = img
        self.spinner.stopAnimating()
    }
    
    func didGetFetchUserResult(_ user: User?) {
        guard let user = user else { return }
        self.imgView.sd_setImage(with: URL(string: user.imgUrl))
        self.nameLabel.text = user.name
    }
}
