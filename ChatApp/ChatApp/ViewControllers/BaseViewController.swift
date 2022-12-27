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
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.tintColor = UIColor(named: "darkBlue")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "darkBlue") ?? UIColor.black, NSAttributedString.Key.font: UIFont(name: "futura-medium", size: 24) ?? UIFont.systemFont(ofSize: 24)
            ]
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    // MARK: - Setting UI Methods
    func setTitleView(_ user: User) {
        self.titleView.setTitleView(with: user)
    }
    
    func setBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToPreVC))
    }
    
    func setDeleteButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(deleteMessage))
    }
    
    // MARK: - Action
    @objc func backToPreVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteMessage() {}
    
    @objc func keyboardWillShow(_ notification: NSNotification) {}

    @objc func keyboardWillHide(_ notification: NSNotification) {}
}
