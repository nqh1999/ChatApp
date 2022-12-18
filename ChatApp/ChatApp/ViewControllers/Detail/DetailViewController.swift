//
//  DetailViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import SDWebImage

final class DetailViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var imgButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var messageTf: BaseTextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var messageView: MessageView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var reactionView: ReactionView!
    @IBOutlet private weak var stackView: UIStackView!
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
    
    convenience init(_ sender: User, _ receiver: User) {
        self.init()
        self.presenter.setData(sender,receiver)
    }
    
    // MARK: - Data Handler Methods
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) { [weak self] in
            self?.presenter.fetchUser { [weak self] user in
                self?.getTitleView().setTitleView(with: user)
            }
            self?.presenter.fetchMessage { [weak self] in
                self?.reloadData()
            }
        }
    }
    
    private func reloadData() {
        self.tableView.reloadData()
        self.scrollToBottom()
    }
    
    private func setupReactionView(_ cell: MessageCell, _ id: String, isSender: Bool) {
        cell.longPress = { [weak self] senderReaction, receiverReaction in
            self?.showReactionView(true)
            self?.reactionView.tapToButton = { [weak self] text in
                if text == senderReaction || text == receiverReaction {
                    self?.presenter.sendReaction(id, "", isSender)
                } else {
                    self?.presenter.sendReaction(id, text, isSender)
                }
                self?.showReactionView(false)
            }
        }
        cell.doubleTapToMessage = { [weak self] in
            self?.presenter.sendReaction(id, "❤️", isSender)
        }
    }
    
    // MARK: - Override Methods
    override func backToPreVC() {
        super.backToPreVC()
        self.presenter.setState()
    }
    
    override func deleteMessage() {
        super.deleteMessage()
        self.messageView.isHidden = false
        self.messageView.showDeleteMessage("Delete all message?")
        self.messageView.confirm = { [weak self] _ in
            self?.spinner.isHidden = false
            self?.spinner.startAnimating()
            self?.presenter.deleteAllMessage { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.tableView.reloadData()
                    self?.spinner.stopAnimating()
                }
            }
        }
    }
    
    private func sendMessage() {
        self.presenter.sendMessage(self.messageTf.text ?? "")
        self.view.endEditing(true)
        self.messageTf.text = ""
        self.messageTf.becomeFirstResponder()
        self.showLikeButton(true)
    }
    
    private func showLikeButton(_ isShow: Bool) {
        self.likeButton.isHidden = !isShow
        self.sendButton.isHidden = isShow
    }
    
    @objc private func tapToView() {
        self.view.endEditing(true)
        self.showReactionView(false)
    }
    
    // MARK: - UI Handler Methods
    private func setupPickerView() {
        self.imgPickerView.delegate = self
        self.imgPickerView.sourceType = .photoLibrary
        self.present(self.imgPickerView, animated: true)
    }
    
    private func setupUI() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToView)))
        self.messageTf.shouldReturn = { [weak self] in
            self?.sendMessage()
        }
        self.setupTableView()
        self.spinner.isHidden = true
        self.messageView.isHidden = true
        self.showLikeButton(true)
        self.showReactionView(false)
    }
    
    func showReactionView(_ isShow: Bool) {
        self.reactionView.isHidden = !isShow
        self.stackView.isHidden = isShow
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
    
    @IBAction func enterMessage(_ sender: UITextField) {
        guard let text = sender.text else { return }
        self.showLikeButton(text.isEmpty)
    }
    
    // MARK: - Button Action
    @IBAction private func chooseImg(_ sender: Any) {
        self.setupPickerView()
    }
    
    @IBAction private func sendMessage(_ sender: Any) {
        self.sendMessage()
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        self.presenter.sendMessage(Emoji.like)
    }
}

// MARK: - Extension
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.originalImage] as! UIImage
        self.presenter.sendImg(img) { [weak self] in
            self?.spinner.stopAnimating()
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
        let message = self.presenter.getMessageBy(index: indexPath.row)
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
                self.setupReactionView(cell, message.messageId, isSender: true)
            } else {
                cell.setupReceivedMessage()
                self.setupReactionView(cell, message.messageId, isSender: false)
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
