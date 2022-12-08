//
//  ListViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

final class ListViewController: UIViewController {

    @IBOutlet private weak var searchBar: BaseTextField!
    @IBOutlet private weak var tableView: UITableView!
    lazy var presenter = ListPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetchUserDetail()
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: .main), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = 5
        searchBar.shouldReturn = { [weak self] in
            self?.view.endEditing(true)
        }
    }
    
    @IBAction private func search(_ sender: UITextField) {
        if let searchText = sender.text {
            self.presenter.filterData(text: searchText)
            self.tableView.reloadData()
        }
    }
    
}
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfFriend()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        cell.fillData(data: presenter.getFriendByIndex(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        guard let data = presenter.getFriendByIndex(index: indexPath.row) else {return}
        vc.presenter.setFriend(data: data)
        vc.presenter.setCurrentId(id: presenter.getCurrentId())
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListViewController: ListProtocol {
    func didGetUser() {
        self.tableView.reloadData()
    }
}
