//
//  ListViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit
import SDWebImage

final class ListViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var searchBar: BaseTextField!
    @IBOutlet private weak var tableView: UITableView!
    lazy private var presenter = ListPresenter(view: self)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    convenience init(_ id: String) {
        self.init()
        self.presenter.setData(id)
    }
    
    // MARK: - Data Handler Methods
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) { [weak self] in
            self?.presenter.fetchUser { [weak self] in
                self?.presenter.fetchMessage { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func goToDetailVCByIndex(index: Int) {
        guard let sender = self.presenter.getSender(), let receiver = self.presenter.getUserBy(index: index) else { return }
        self.navigationController?.pushViewController(DetailViewController(sender, receiver), animated: true)
    }
    
    // MARK: - UI Handler Methods
    private func setupUI() {
        self.setupTableView()
        self.setupSearchBar()
        self.navigationItem.titleView = nil
        self.title = "Chats"
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "ListTableViewCell", bundle: .main), forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupSearchBar() {
        self.searchBar.layer.cornerRadius = 10
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.masksToBounds = true
        self.searchBar.shouldReturn = { [weak self] in
            self?.view.endEditing(true)
        }
    }
    
    // search by name
    @IBAction private func search(_ sender: UITextField) {
        guard let text = sender.text else { return }
        self.presenter.filterData(text: text)
        self.tableView.reloadData()
    }
}

// MARK: - Extension
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getNumberOfUser()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        guard let user = self.presenter.getUserBy(index: indexPath.row) else { return cell}
        cell.fillData(self.presenter.getUserBy(index: indexPath.row), self.presenter.getMessageBy(id: user.id))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToDetailVCByIndex(index: indexPath.row)
        guard let sender = self.presenter.getSender(), let receiver = self.presenter.getUserBy(index: indexPath.row) else { return }
        guard let message = self.presenter.getMessageBy(id: receiver.id) else { return }
        if message.receiverId == sender.id {
            self.presenter.setState(sender, receiver)
        }
    }
}

extension ListViewController: ListProtocol {
    
}
