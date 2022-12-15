//
//  DetailViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit

final class DetailViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var imgButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var messageTf: BaseTextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var messageView: MessageView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    private var imgPickerView = UIImagePickerController()
    lazy private var presenter = DetailPresenter(view: self)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBackButton()
        self.setDeleteButton()
    }
    
    // MARK: - Methods
    override func backToPreVC() {
        super.backToPreVC()
        self.presenter.setState()
    }
    
    private func setupUI() {
        self.messageTf.shouldReturn = { [weak self] in
            self?.sendMessage()
        }
        self.setupTableView()
        self.spinner.isHidden = true
        self.messageView.isHidden = true
    }
    
    override func deleteMessage() {
        super.deleteMessage()
        self.messageView.isHidden = false
        self.messageView.showDeleteMessage("Delete all message?")
        self.messageView.confirm = { [weak self] _ in
            self?.spinner.isHidden = false
            self?.spinner.startAnimating()
            self?.presenter.deleteAllMessage {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.tableView.reloadData()
                    self?.spinner.stopAnimating()
                }
            }
        }
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "MessageCell", bundle: .main), forCellReuseIdentifier: "messageCell")
        self.tableView.register(UINib(nibName: "ImgCell", bundle: .main), forCellReuseIdentifier: "imgCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async {
            guard self.presenter.getNumberOfMessage() > 0 else { return }
            let indexPath = IndexPath(row: self.presenter.getNumberOfMessage()-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func setupPickerView() {
        self.imgPickerView.delegate = self
        self.imgPickerView.sourceType = .photoLibrary
        self.present(self.imgPickerView, animated: true)
    }
    
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) {
            self.presenter.fetchUser { user in
                self.getTitleView().setTitleView(data: user)
            }
            self.presenter.fetchMessage {
                self.reloadData()
            }
        }
    }
    
    func getPresenter() -> DetailPresenter {
        return self.presenter
    }
    
    private func sendMessage() {
        self.presenter.sendMessage(self.messageTf.text ?? "")
        self.view.endEditing(true)
        self.messageTf.text = ""
        self.messageTf.becomeFirstResponder()
    }
    
    private func reloadData() {
        self.tableView.reloadData()
        self.scrollToBottom()
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
        self.presenter.sendImg(img: img) {
            self.spinner.stopAnimating()
        }
        self.imgPickerView.dismiss(animated: true)
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getNumberOfMessage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.presenter.getMessageByIndex(index: indexPath.row)
        if message.text.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imgCell", for: indexPath) as! ImgCell
            cell.setupImg(message)
            if message.senderId == self.presenter.getSender()?.id {
                cell.setupSentImg()
            } else {
                cell.setupReceivedImg()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
            cell.setupData(message)
            if message.senderId == self.presenter.getSender()?.id {
                cell.setupSentMessage()
            } else {
                cell.setupReceivedMessage()
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DetailViewController: DetailProtocol {
   
}
