//
//  ListViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

final class ListViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var searchBar: BaseTextField!
    @IBOutlet private weak var tableView: UITableView!
    lazy private var presenter = ListPresenter(view: self)
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupUI()
    }
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
    }
    private func setupSearchBar() {
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.cornerRadius = 5
        self.searchBar.shouldReturn = { [weak self] in
            self?.view.endEditing(true)
        }
    }
    func getPresenter() -> ListPresenter {
        return self.presenter
    }
    // search by name
    @IBAction private func search(_ sender: UITextField) {
        if let text = sender.text {
            self.presenter.filterData(text: text)
            self.tableView.reloadData()
        }
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
        let vc = DetailViewController()
        guard let data = self.presenter.getUserByIndex(index: indexPath.row) else {return}
        vc.getPresenter().setReceiver(data: data)
        vc.getPresenter().setCurrentId(id: self.presenter.getCurrentId())
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListViewController: ListProtocol {
    func didGetUser() {
        self.tableView.reloadData()
    }
}
