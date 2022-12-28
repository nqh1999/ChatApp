import UIKit
import RxSwift
import RxRelay
import RxCocoa

protocol RxProtocol: AnyObject {
    func didGetUser(_ users: PublishSubject<[User]>)
}

class RxPresenter {
    private weak var view: RxProtocol?
    private var users = PublishSubject<[User]>()
    // MARK: - Init
    init(view: RxProtocol) {
        self.view = view
    }
    
    func fetchUser() {
        FirebaseService.shared.fetchUser { users in
            self.users.onNext(users)
            self.view?.didGetUser(self.users)
        }
    }
}
class RxViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    lazy private var presenter = RxPresenter(view: self)
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ListTableViewCell", bundle: .main), forCellReuseIdentifier: "cell")
        self.presenter.fetchUser()
    }
}

extension RxViewController: RxProtocol {
    func didGetUser(_ users: PublishSubject<[User]>) {
        users.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: ListTableViewCell.self)) {row, user, cell in
            cell.fillData(user, nil)
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(User.self).bind { user in
            print(user.username)
        }.disposed(by: bag)
    }
}
