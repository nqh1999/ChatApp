//
//  ListViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setLogoutButton()
    }
    
    // MARK: - Methods
    private func setupUI() {
        self.setupTableView()
        self.setupSearchBar()
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
    
    func getPresenter() -> ListPresenter {
        return self.presenter
    }
    
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) {
            self.presenter.fetchUser() {
                self.presenter.fetchMessage {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // send data and go to detail view controller when click to row of table view
    private func goToDetailVCByIndex(index: Int) {
        guard let sender = self.presenter.getSender(), let receiver = self.presenter.getUserByIndex(index: index) else { return }
        let vc = DetailViewController()
        vc.getPresenter().setData(sender: sender, receiver: receiver)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // search by name
    @IBAction private func search(_ sender: UITextField) {
        guard let text = sender.text else { return }
        self.presenter.filterData(text: text)
        self.tableView.reloadData()
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getNumberOfUser()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        cell.fillData(user: self.presenter.getUserByIndex(index: indexPath.row), message: self.presenter.getMessageById(self.presenter.getUserByIndex(index: indexPath.row)!.id))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToDetailVCByIndex(index: indexPath.row)
        guard let sender = self.presenter.getSender(), let receiver = self.presenter.getUserByIndex(index: indexPath.row) else { return }
        guard let message = self.presenter.getMessageById(receiver.id) else { return }
        if message.receiverId == sender.id {
            self.presenter.setState(sender, receiver)
        }
    }
}

extension ListViewController: ListProtocol {
    
}

