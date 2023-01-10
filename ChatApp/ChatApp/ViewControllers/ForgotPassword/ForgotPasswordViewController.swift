//
//  ForgotPasswordViewController.swift
//  ChatApp
//
//  Created by BeeTech on 15/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

final class ForgotPasswordViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var usernameTf: BaseTextField!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var resetPasswordButton: CustomButton!
    @IBOutlet private weak var messageView: MessageView!
    lazy private var presenter = ForgotPasswordPresenter(view: self)
    private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
        self.setupButton()
    }
    
    // MARK: - Data Handler Methods
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) { [weak self] in
            self?.presenter.fetchUser()
        }
    }
    
    private func resetPassword() {
        self.presenter.checkUsername(self.usernameTf.text ?? "")
    }
    
    // MARK: - UI Handler Methods
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.messageView.isHidden = true
        
        self.usernameTf.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .subscribe { [weak self] _ in
                self?.usernameTf.resignFirstResponder()
                self?.resetPassword()
            }
            .disposed(by: disposeBag)
    }

    // MARK: Button Action
    private func setupButton() {
        self.resetPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.resetPassword()
            })
            .disposed(by: self.disposeBag)
        
        self.cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
}


// MARK: - Extension
extension ForgotPasswordViewController: ForgotPasswordProtocol {
    func didGetValidateUsernameResult(result: String?, newPass: String) {
        self.messageView.isHidden = false
        if let result = result {
            self.messageView.showMessage(result)
        } else {
            self.messageView.showMessage("New password is \(newPass)")
            self.messageView.confirm = { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
