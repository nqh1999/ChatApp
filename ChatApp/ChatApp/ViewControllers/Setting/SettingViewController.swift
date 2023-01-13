//
//  SettingViewController.swift
//  ChatApp
//
//  Created by BeeTech on 14/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

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
    private var imgPickerView = UIImagePickerController()
    
    lazy private var presenter = SettingPresenter(view: self)
    private let disposeBag = DisposeBag()
    
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
    
    // MARK: Setup UI
    private func setupUI() {
        self.imgView.layer.cornerRadius = self.imgView.frame.width / 2
        self.imgView.layer.borderWidth = 2
        self.imgView.layer.borderColor = UIColor.black.cgColor
        self.spinner.isHidden = true
        self.navigationItem.titleView = nil
        self.title = "Setting"
        self.messageView.isHidden = true
        self.setupButton()
    }
    
    // MARK: Setup Picker View
    private func setupPickerView() {
        self.imgPickerView.delegate = self
        self.imgPickerView.sourceType = .photoLibrary
        self.imgPickerView.allowsEditing = true
        self.present(self.imgPickerView, animated: true)
    }
    
    // MARK: Setup Data
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) { [weak self] in
            self?.presenter.fetchUser()
        }
    }
    
    // MARK: Change name
    private func changeName(_ name: String) {
        guard !name.isEmpty else { return }
        self.presenter.changeName(name)
        self.nameLabel.text = name
        self.messageView.isHidden = true
    }
    
    // MARK: Set Image
    private func setImage(_ img: UIImage) {
        self.presenter.setImgUrl(img)
    }
    
    // MARK: Setup Button
    private func setupButton() {
        self.logoutButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.presenter.logout()
            (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController = UINavigationController(rootViewController: LoginViewController())
        })
        .disposed(by: self.disposeBag)
        
        self.chooseImageButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.setupPickerView()
        })
        .disposed(by: self.disposeBag)
        
        self.editName.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.presenter.logout()
            self?.messageView.isHidden = false
            self?.messageView.showChangeNameMessage { [weak self] name in
                self?.changeName(name)
            }
            self?.messageView.confirm = { [weak self] name in
                self?.changeName(name)
            }
        })
        .disposed(by: self.disposeBag)
        
        self.changePasswordButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.pushViewController(ChangePasswordViewController(self?.presenter.getUser()), animated: true)
        })
        .disposed(by: self.disposeBag)
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
