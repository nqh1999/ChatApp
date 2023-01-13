//
//  DetailViewController.swift
//  ChatApp
//
//  Created by BeeTech on 07/12/2022.
//

import UIKit
import SDWebImage
import RxCocoa
import RxSwift

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
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    
    lazy private var presenter = DetailPresenter(view: self)
    lazy private var disposeBag = DisposeBag()
    
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
    
    // MARK: - Setup Data
    private func setupData() {
        UIView.animate(withDuration: 0, delay: 0) { [weak self] in
            self?.presenter.fetchMessage()
        }
    }
    
    // MARK: Reload TableView
    private func reloadData() {
//        self.tableView.reloadData()
        self.view.layoutIfNeeded()
        self.scrollToBottom()
    }
    
    // MARK: Setup ReactionView
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
    
    // MARK: Back To Previous VC
    override func backToPreVC() {
        super.backToPreVC()
        self.presenter.setState()
    }
    
    // MARK: Delete Message
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
    
    // MARK: Send Message
    private func sendMessage(_ message: String) {
        self.presenter.sendMessage(message)
        self.messageTextView.text = ""
        self.showLikeButton(true)
        self.heightConstraint.constant = 39
    }
    
    // MARK: Show like button
    private func showLikeButton(_ isShow: Bool) {
        self.likeButton.isHidden = !isShow
        self.sendButton.isHidden = isShow
    }
    
    // MARK: Scroll to bottom
    private func scrollToBottom() {
        DispatchQueue.main.async { [weak self] in
            guard let count = self?.presenter.getNumberOfMessage(), count > 0 else { return }
            let indexPath = IndexPath(row: count-1, section: 0)
            self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: Handler event show - hide keyboard
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
    
    // MARK: Setup Picker View
    private func setupPickerView() {
        self.imgPickerView.delegate = self
        self.imgPickerView.sourceType = .photoLibrary
        self.present(self.imgPickerView, animated: true)
    }
    
    // MARK: Setup UI
    private func setupUI() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToView)))
        self.spinner.isHidden = true
        self.messageView.isHidden = true
        self.showLikeButton(true)
        self.showReactionView(false)
        self.setupTableView()
        self.setupButton()
        self.setupTextView()
    }
    
    // MARK: Setup TextView
    private func setupTextView() {
        self.messageTextView.didChange = { [weak self] text in
            guard let contentHeight = self?.messageTextView.contentSize.height else { return }
            self?.heightConstraint.constant = (contentHeight < 130) ? contentHeight : 130
            self?.view.layoutIfNeeded()
            self?.showLikeButton(text.isEmpty)
        }
    }
    
    // MARK: Show reaction view
    private func showReactionView(_ isShow: Bool) {
        self.reactionView.isHidden = !isShow
        self.stackView.isHidden = isShow
    }
    
    // MARK: Setup Table View
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "MessageCell", bundle: .main), forCellReuseIdentifier: "messageCell")
        self.tableView.register(UINib(nibName: "ImgCell", bundle: .main), forCellReuseIdentifier: "imgCell")
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    @objc private func tapToView() {
        self.view.endEditing(true)
        self.showReactionView(false)
    }
    
    // MARK: - Setup Button
    private func setupButton() {
        self.imgButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.setupPickerView()
        })
        .disposed(by: self.disposeBag)
        
        self.sendButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.sendMessage(self?.messageTextView.text ?? "")
        })
        .disposed(by: self.disposeBag)
        
        self.likeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.sendMessage("👍")
        })
        .disposed(by: self.disposeBag)
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

extension DetailViewController: UITableViewDelegate {
    
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
    
    func didGetFetchMessageResult(_ messages: RxRelay.BehaviorRelay<[Message]>, _ sender: User?) {
        messages.bind(to: self.tableView.rx.items) { [weak self] tableview, index, message in
            guard let senderId = sender?.id else { return UITableViewCell() }
            if message.text.isEmpty {
                let cell = tableview.dequeueReusableCell(withIdentifier: "imgCell") as! ImgCell
                cell.setupImg(message)
                if message.senderId == senderId {
                    cell.setupSentImg()
                } else {
                    cell.setupReceivedImg()
                }
                return cell
            } else {
                let cell = tableview.dequeueReusableCell(withIdentifier: "messageCell") as! MessageCell
                if message.senderId == senderId {
                    cell.setupSentMessage(message)
                    self?.setupReactionView(cell, message.messageId)
                } else {
                    cell.setupReceivedMessage(message)
                    self?.setupReactionView(cell, message.messageId)
                }
                return cell
            }
        }
        .disposed(by: self.disposeBag)
        
        messages.subscribe(onNext: { [weak self] _ in
            self?.reloadData()
        })
        .disposed(by: self.disposeBag)
    }
    
    func didGetDeleteMessageResult() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.tableView.reloadData()
            self?.spinner.stopAnimating()
        }
    }
    
    func didGetSendImageResult() {
        self.spinner.stopAnimating()
        self.reloadData()
    }
    
    func didSendMessage() {
        self.reloadData()
    }
}
