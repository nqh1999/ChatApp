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
    @IBOutlet private weak var messageTextView: CustomTextView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var messageView: MessageView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var reactionView: ReactionView!
    @IBOutlet private weak var stackView: UIStackView!
    private var imgPickerView = UIImagePickerController()
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
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
        self.tabBarController?.tabBar.isHidden = true
        self.messageTextView.text = ""
    }
    
    convenience init(_ sender: User, _ receiver: User) {
        self.init()
        self.presenter.setData(sender,receiver)
    }
    
    // MARK: - Data Handler Methods
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) { [weak self] in
            self?.presenter.fetchUser()
            self?.presenter.fetchMessage()
        }
    }
    
    private func reloadData() {
        self.tableView.reloadData()
        self.scrollToBottom()
    }
    
    private func setupReactionView(_ cell: MessageCell, _ id: String) {
        cell.longPress = { [weak self] reaction in
            self?.showReactionView(true)
            self?.reactionView.tapToButton = { [weak self] text in
                if text == reaction {
                    self?.presenter.sendReaction(id, "")
                } else {
                    self?.presenter.sendReaction(id, text)
                }
                self?.showReactionView(false)
            }
        }
        cell.doubleTapToMessage = { [weak self] in
            self?.presenter.sendReaction(id, "❤️")
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
            self?.presenter.deleteAllMessage()
        }
    }
    
    private func sendMessage() {
        self.presenter.sendMessage(self.messageTextView.text ?? "")
        self.messageTextView.text = ""
        self.showLikeButton(true)
    }
    
    private func showLikeButton(_ isShow: Bool) {
        self.likeButton.isHidden = !isShow
        self.sendButton.isHidden = isShow
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async {
            guard self.presenter.getNumberOfMessage() > 0 else { return }
            let indexPath = IndexPath(row: self.presenter.getNumberOfMessage()-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    override func keyboardWillShow(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        self.bottomConstraint.constant = keyboardHeight + 6
        self.view.layoutIfNeeded()
        self.scrollToBottom()
    }
    
    override func keyboardWillHide(_ notification: NSNotification) {
        self.bottomConstraint.constant = 10
        self.view.layoutIfNeeded()
        self.scrollToBottom()
    }
    
    // MARK: - UI Handler Methods
    private func setupPickerView() {
        self.imgPickerView.delegate = self
        self.imgPickerView.sourceType = .photoLibrary
        self.present(self.imgPickerView, animated: true)
    }
    
    private func setupUI() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToView)))
        self.setupTableView()
        self.spinner.isHidden = true
        self.messageView.isHidden = true
        self.showLikeButton(true)
        self.showReactionView(false)
        self.messageTextView.didChange = { [weak self] text in
            self?.showLikeButton(text.isEmpty)
        }
        self.messageTextView.shouldReturn = { [weak self] in
            self?.sendMessage()
        }
    }
    
    private func showReactionView(_ isShow: Bool) {
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
    
    @objc private func tapToView() {
        self.view.endEditing(true)
        self.showReactionView(false)
    }
    
    // MARK: - Action Methods
    @IBAction private func chooseImg(_ sender: Any) {
        self.setupPickerView()
    }
    
    @IBAction private func sendMessage(_ sender: Any) {
        self.sendMessage()
    }
    
    @IBAction private func likeButtonTapped(_ sender: Any) {
        self.presenter.sendMessage("👍")
    }
}

// MARK: - Extension
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.originalImage] as! UIImage
        self.presenter.sendImg(img)
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
            if message.senderId == self.presenter.getSender()?.id {
                cell.setupSentMessage(message)
                self.setupReactionView(cell, message.messageId)
            } else {
                cell.setupReceivedMessage(message)
                self.setupReactionView(cell, message.messageId)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = self.presenter.getMessageBy(index: indexPath.row)
        if message.text.isEmpty {
            return 280/(message.ratio)
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension DetailViewController: DetailProtocol {
    func didGetFetchUserResult(_ user: User) {
        self.setTitleView(user)
    }
    
    func didGetFetchMessageResult() {
        self.reloadData()
    }
    
    func didGetDeleteMessageResult() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.tableView.reloadData()
            self?.spinner.stopAnimating()
        }
    }
    
    func didGetSendImageResult() {
        self.spinner.stopAnimating()
    }
    
   
}
