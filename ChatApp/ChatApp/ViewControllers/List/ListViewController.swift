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
        self.setupData()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setLogoutButton()
    }
    
    // MARK: - Methods
    private func setupUI() {
        self.setupTableView()
        self.setupSearchBar()
    }
    
    private func setupData() {
        self.presenter.fetchUserDetail()
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
    
    // send data and go to detail view controller when click to row of table view
    private func goToDetailVCByIndex(index: Int) {
        guard let data = self.presenter.getUserByIndex(index: index) else { return }
        let vc = DetailViewController()
        vc.getPresenter().setReceiver(data: data)
        vc.getPresenter().setCurrentId(id: self.presenter.getCurrentId())
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
        cell.fillData(data: self.presenter.getUserByIndex(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToDetailVCByIndex(index: indexPath.row)
    }
}

extension ListViewController: ListProtocol {
    func didGetUser() {
        self.tableView.reloadData()
    }
}
