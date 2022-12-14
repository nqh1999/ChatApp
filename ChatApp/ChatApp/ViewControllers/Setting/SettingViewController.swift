//
//  SettingViewController.swift
//  ChatApp
//
//  Created by BeeTech on 14/12/2022.
//

import UIKit

class SettingViewController: BaseViewController {
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var chooseImageButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var editProfileButton: CustomButton!
    @IBOutlet private weak var changePasswordButton: CustomButton!
    @IBOutlet private weak var logoutButton: CustomButton!
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
    
    // MARK: - Methods
    private func setupUI() {
        self.setBackButton()
        self.imgView.layer.cornerRadius = self.imgView.frame.width / 2
        self.imgView.layer.borderWidth = 2
        self.imgView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) {
            self.presenter.fetchUser() { user in
                guard let user = user else { return }
                self.imgView.sd_setImage(with: URL(string: user.imgUrl))
                self.nameLabel.text = user.name
            }
        }
    }
    
    private func setupPickerView() {
        self.imgPickerView.delegate = self
        self.imgPickerView.sourceType = .photoLibrary
        self.present(self.imgPickerView, animated: true)
    }
    
    func getPresenter() -> SettingPresenter {
        return self.presenter
    }
    
    @IBAction func logout(_ sender: Any) {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
    
    @IBAction func chooseImg(_ sender: Any) {
        
    }
    
    
    @IBAction func goToEditProfileView(_ sender: Any) {
        
    }
    
    
    @IBAction func goToChangePasswordView(_ sender: Any) {
        
    }
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension SettingViewController: SettingProtocol {
    
}
