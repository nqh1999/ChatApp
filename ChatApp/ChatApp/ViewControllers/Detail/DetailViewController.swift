//
//  DetailViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var imgButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var messageTf: BaseTextField!
    @IBOutlet private weak var tableView: UITableView!
    private let titleView = NavigationTitleView()
    private var imgPickerView = UIImagePickerController()
    lazy private var presenter = DetailPresenter(view: self)
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupUI()
    }
    func setupUI() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToPreVC))
        self.navigationItem.titleView = titleView
        self.titleView.setTitle(data: self.presenter.getReceiver())
        self.messageTf.shouldReturn = { [weak self] in
            self?.sendMessage()
        }
        self.setupTableView()
    }
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "MyCell", bundle: .main), forCellReuseIdentifier: "mycell")
        self.tableView.register(UINib(nibName: "FriendCell", bundle: .main), forCellReuseIdentifier: "friendcell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if self.tableView.rowHeight > 50 {
            self.tableView.rowHeight = UITableView.automaticDimension
        } else {
            self.tableView.rowHeight = 50
        }
    }
    private func setupPickerView() {
        self.imgPickerView.delegate = self
        self.imgPickerView.sourceType = .photoLibrary
        present(self.imgPickerView, animated: true)
    }
    private func setupData() {
        self.presenter.fetchMessage()
    }
    func getPresenter() -> DetailPresenter {
        return self.presenter
    }
    private func sendMessage() {
        self.presenter.sendMessage(text: self.messageTf.text ?? "")
        self.view.endEditing(true)
        self.messageTf.text = ""
        self.presenter.fetchMessage()
    }
    @objc private func backToPreVC() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction private func chooseImg(_ sender: Any) {
        self.setupPickerView()
    }
    
    @IBAction private func sendMessage(_ sender: Any) {
        self.sendMessage()
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.presenter.sendImg(img: img)
        self.imgPickerView.dismiss(animated: true)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getNumberOfMessage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.presenter.getMessageByIndex(index: indexPath.row)
        // sai
        if message.senderId == self.presenter.getCurrentId() {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! MyCell
            cell.setupData(data: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendcell", for: indexPath) as! FriendCell
            cell.setupData(data: message)
            return cell
        }
    }
}

extension DetailViewController: DetailProtocol {
    func didGetMessage() {
        self.tableView.reloadData()
    }
}
