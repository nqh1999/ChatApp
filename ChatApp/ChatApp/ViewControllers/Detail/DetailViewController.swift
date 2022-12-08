//
//  DetailViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    @IBOutlet private weak var imgButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var messageTf: BaseTextField!
    @IBOutlet private weak var tableView: UITableView!
    private let titleView = NavigationTitleView()
    lazy var presenter = DetailPresenter(view: self)
    private let storage = Storage.storage()
    
    private var imgPickerView = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetchMessage()
        setupUI()
    }
    func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToPreVC))
        navigationItem.titleView = titleView
        titleView.setTitle(data: presenter.getFriend())
        messageTf.shouldReturn = { [weak self] in
            self?.sendMessage()
        }
        tableView.register(UINib(nibName: "MyCell", bundle: .main), forCellReuseIdentifier: "mycell")
        tableView.register(UINib(nibName: "FriendCell", bundle: .main), forCellReuseIdentifier: "friendcell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    private func setupPickerView() {
        self.imgPickerView.delegate = self
        self.imgPickerView.sourceType = .photoLibrary
        present(self.imgPickerView, animated: true)
    }
    private func sendMessage() {
        presenter.sendMessage(text: messageTf.text)
        view.endEditing(true)
        messageTf.text = ""
        presenter.fetchMessage()
    }
    @IBAction func chooseImg(_ sender: Any) {
        setupPickerView()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        sendMessage()
    }
    
    @objc private func backToPreVC() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        presenter.sendImg(img: img)
        self.imgPickerView.dismiss(animated: true)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfMessage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = presenter.getMessageByIndex(index: indexPath.row)
        if message.senderId == presenter.getCurrentId() {
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
