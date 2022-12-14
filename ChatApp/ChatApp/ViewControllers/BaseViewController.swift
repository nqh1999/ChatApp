//
//  BaseViewController.swift
//  ChatApp
//
//  Created by BeeTech on 09/12/2022.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Properties
    private let titleView = NavigationTitleView()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.contents = UIImage(named: "bgr")?.cgImage
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - Methods
    func getTitleView() -> NavigationTitleView {
        return titleView
    }
    
    func setBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToPreVC))
    }
    
    func setSettingButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(setting))
    }
    
    func setDeleteButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(deleteMessage))
    }
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc func deleteMessage() {}
    
    @objc func backToPreVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setting() {}
}
