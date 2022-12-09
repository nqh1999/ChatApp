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
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    // MARK: - Methods
    func getTitleView() -> NavigationTitleView {
        return titleView
    }
    
    // back button
    func setBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToPreVC))
    }
    
    // logout button
    func setLogoutButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logout))
    }
    
    @objc private func backToPreVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func logout() {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
}
