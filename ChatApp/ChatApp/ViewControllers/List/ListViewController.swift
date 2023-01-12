//
//  ListViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

final class ListViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var searchBar: BaseTextField!
    @IBOutlet private weak var tableView: UITableView!
    lazy private var presenter = ListPresenter(view: self)
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    convenience init(_ id: String) {
        self.init()
        self.presenter.setData(id)
    }
    
    // MARK: - Setup Data
    private func setupData() {
        self.presenter.fetchData()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.setupTableView()
        self.setupSearchBar()
        self.navigationItem.titleView = nil
        self.title = "Chats"
    }
    
    // MARK: Setup Table View
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "ListTableViewCell", bundle: .main), forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.rx.modelSelected((User,Message?).self).subscribe(onNext: { [weak self] receiver, message in
            guard let sender = self?.presenter.getSender() else { return }
            self?.navigationController?.pushViewController(DetailViewController(sender, receiver), animated: true)
            self?.presenter.setState(sender, receiver, message)
        })
        .disposed(by: self.disposeBag)
    }

    // MARK: Setup Search Bar
    private func setupSearchBar() {
        self.searchBar.layer.cornerRadius = 10
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.masksToBounds = true
        self.searchBar.rx.controlEvent(.editingDidEndOnExit).subscribe { [weak self] _ in
            self?.view.endEditing(true)
        }
        .disposed(by: self.disposeBag)
        
        self.searchBar.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] _ in
            self?.presenter.searchUserWithText(self?.searchBar.text)
        })
        .disposed(by: self.disposeBag)
    }
}

// MARK: - Extension
extension ListViewController: ListProtocol {
    func didFetchData(_ observable: BehaviorRelay<[(User, Message?)]>) {
        observable.bind(to: self.tableView.rx.items(cellIdentifier: "cell", cellType: ListTableViewCell.self)) { row, data, cell in
            cell.fillData(data.0, data.1)
        }
        .disposed(by: disposeBag)
    }
}
