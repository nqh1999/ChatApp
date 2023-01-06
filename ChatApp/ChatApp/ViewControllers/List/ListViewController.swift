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
import RxRelay

final class ListViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var searchBar: BaseTextField!
    @IBOutlet private weak var tableView: UITableView!
    lazy private var presenter = ListPresenter(view: self)
    lazy private var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.setupData()
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
        self.presenter.fetchData()
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
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        
        self.dataObservable()
          .flatMap { Observable.from($0) }
          .flatMapLatest { [weak self] user -> Observable<(User?, Message?)> in
            guard let senderId = self?.presenter.getSenderId(), let id = user.lastMessages[senderId] else { return Observable.just((user, nil)) }
            return self!.presenter.fetchMessageById(id)
              .map { message -> (User?, Message?) in (user, message) }
          }
          .bind(to: self.tableView.rx.items(cellIdentifier: "cell", cellType: ListTableViewCell.self)) { row, element, cell in
//            let (user, message) = element
//            cell.fillData(user, message) 
          }
          .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(User.self)
            .subscribe(onNext: { [weak self] receiver in
                guard let sender = self?.presenter.getSender() else { return }
                self?.navigationController?.pushViewController(DetailViewController(sender, receiver), animated: true)
                //                guard let message = receiver.lastMessages[sender.id] else { return }
                //                if message.receiverId == sender.id {
                //                    self?.presenter.setState(sender, data.0)
                //                }
            })
            .disposed(by: self.disposeBag)
        
    }
    
    private func setupSearchBar() {
        self.searchBar.layer.cornerRadius = 10
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.masksToBounds = true
        self.searchBar.rx
            .controlEvent(.editingDidEndOnExit)
            .subscribe { [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: self.disposeBag)
//        setupSearch()
    }
    
//    private func setupSearch() {
//        var data: [User] = []
//
//        self.searchBar.rx.text
//            .orEmpty
//            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .subscribe(onNext: { [weak self] query in
//                self?.presenter.sett(self?.searchBar.text?.isEmpty ?? true)
//                if query.isEmpty {
//                    return
//                }
//                let filteredData = data.filter { user in
//                    user.name.lowercased().contains(query.lowercased())
//                }
////                data.accept(filteredData)
//                self?.tableView.reloadData()
//            })
//            .disposed(by: self.disposeBag)
//    }

}

// MARK: - Extension
extension ListViewController: ListProtocol {
    func dataObservable() -> Observable<[User]> {
        return self.presenter.dataObservable()
    }
}
