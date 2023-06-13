//
//  BaseViewController.swift
//  ChatApp
//
//  Created by BeeTech on 09/12/2022.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    // MARK: - Properties
    let titleView = NavigationTitleView()
    let disposeBag = DisposeBag()
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
        setupTap()
        setupTableView()
        setupCollectionView()
    }
    
    func setupUI() {
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.tintColor = UIColor(named: "darkBlue")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "darkBlue") ?? UIColor.black, NSAttributedString.Key.font: UIFont(name: "futura-medium", size: 24) ?? UIFont.systemFont(ofSize: 24)
            ]
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    func setupRx() {}
    func setupTap() {}
    func setupTableView() {}
    func setupCollectionView() {}
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func push(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: Setup Tabbar
    func createTabBar() {
        let senderId = SharedData.shared.getUserId()
        let tabBar = UITabBarController()
        let listNav = UINavigationController(rootViewController: ListViewController(senderId))
        let settingNav = UINavigationController(rootViewController: SettingViewController(senderId))
        listNav.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message.fill"), tag: 0)
        settingNav.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "person.circle.fill"), tag: 1)
        tabBar.setViewControllers([listNav, settingNav], animated: false)
        tabBar.tabBar.tintColor = .blue
        tabBar.tabBar.unselectedItemTintColor = .gray
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController =
        tabBar
    }
    
    func setBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToPreVC))
    }
    
    func setDeleteButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(deleteMessage))
    }
    
    @objc func backToPreVC() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func deleteMessage() {}
    @objc func keyboardWillShow(_ notification: NSNotification) {}
    @objc func keyboardWillHide(_ notification: NSNotification) {}
}
