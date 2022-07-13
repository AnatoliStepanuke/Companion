import UIKit
import Firebase

final class ChatCollectionViewController:
    UICollectionViewController,
    UITextFieldDelegate,
    UICollectionViewDelegateFlowLayout {

    // MARK: - Constants
    // MARK: Private
    private let databaseReferenceToMessagesCache = FirebaseManager.instance.databaseReferenceToMessagesCache
    private let databaseReferenceToTeachers = FirebaseManager.instance.databaseReferenceToTeachers
    private let databaseReferenceToUserMessages = FirebaseManager.instance.databaseReferenceToMessagesByPerUser
    private let chatInputStackView = UIStackView()
    private let initialsStackView = UIStackView()
    private let sendButton = CustomPlainUIButton(systemName: "paperplane", title: nil)
    private let inputTextField = UITextField()
    private let companionLabel = UILabel()
    private let messageFrameSize = CGSize(width: 250, height: 500)
    private let drawingOptions = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

    // MARK: - Properties
    // MARK: Private
    private var messages: [Chat] = []
    private var messageHeight: CGFloat?
    private var chatInputStackViewBottomAnchor: NSLayoutConstraint?

    // MARK: Public
    var user: User? {
        didSet {
            companionLabel.text = user?.name
            fetchMessages()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupChatInputStackView()
        setupInputTextField()
        setupSendButton()
        setupInitialsStackView()
        setupCompanionLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        handleKeyboardObservers()
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeHandleKeyboardObservers()
    }

    // MARK: - Setups
    private func setupCollectionView() {
        collectionView.customContentViewDistanceSafeArea(
            collectionView: collectionView,
            top: 64,
            left: 0,
            right: 0,
            bottom: 64
        )
        collectionView?.customScrollViewDistanceSafeArea(
            collectionView: collectionView,
            top: 64,
            left: 0,
            right: 0,
            bottom: 64
        )
        collectionView.addSubview(chatInputStackView)
        collectionView.addSubview(initialsStackView)
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.Constants.messageCell)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }

    private func setupColorMessageCell(message: Chat, cell: MessageCell) {
        if message.fromUserID == Auth.auth().currentUser?.uid {
            cell.messageBubbleView.backgroundColor = .systemBlue
            cell.messageTextView.textColor = .white
            cell.messageBubbleRightAnchor?.isActive = true
            cell.messageBubbleLeftAnchor?.isActive = false
        } else {
            cell.messageBubbleView.backgroundColor = .systemGray5
            cell.messageTextView.textColor = .black
            cell.messageBubbleRightAnchor?.isActive = false
            cell.messageBubbleLeftAnchor?.isActive = true
        }
    }

    private func setupWidthMessageCell(indexPath: IndexPath, cell: MessageCell) {
        if let text = messages[indexPath.row].text {
            cell.messageBubbleWidth?.constant = estimateFrameForTextMessage(text: text).width + 32
            cell.messageTextView.isHidden = false
        }
    }

    private func setupHeightMessageCell(indexPath: IndexPath) {
        if let text = messages[indexPath.item].text {
            messageHeight = estimateFrameForTextMessage(text: text).height + 32
        }
    }

    private func setupChatInputStackView() {
        chatInputStackView.anchor(
            top: nil,
            leading: collectionView.safeAreaLayoutGuide.leadingAnchor,
            trailing: collectionView.safeAreaLayoutGuide.trailingAnchor,
            bottom: nil,
            size: .init(width: 0, height: 70)
        )
        chatInputStackViewBottomAnchor = chatInputStackView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor
        )
        chatInputStackViewBottomAnchor?.isActive = true
        chatInputStackView.addArrangedSubview(inputTextField)
        chatInputStackView.addArrangedSubview(sendButton)
        chatInputStackView.alignment = .lastBaseline
        chatInputStackView.distribution = .equalCentering
        chatInputStackView.backgroundColor = UIColor(white: 1, alpha: 0.9)
    }

    private func setupInputTextField() {
        inputTextField.widthAnchor.constraint(equalTo: chatInputStackView.widthAnchor, multiplier: 0.85
        ).isActive = true
        inputTextField.anchor(
            top: nil,
            leading: chatInputStackView.leadingAnchor,
            trailing: nil,
            bottom: nil,
            padding: .init(top: 0, left: 12, bottom: 0, right: 0)
        )
        inputTextField.delegate = self
        inputTextField.placeholder = "Enter message..."
        inputTextField.autocapitalizationType = .sentences
        inputTextField.keyboardType = .default
        inputTextField.returnKeyType = .send
    }

    private func setupSendButton() {
        sendButton.addTarget(self, action: #selector(sendButtonDidTapped), for: .touchUpInside)
    }

    private func setupInitialsStackView() {
        initialsStackView.anchor(
            top: collectionView.safeAreaLayoutGuide.topAnchor,
            leading: collectionView.safeAreaLayoutGuide.leadingAnchor,
            trailing: collectionView.safeAreaLayoutGuide.trailingAnchor,
            bottom: nil,
            size: .init(width: 0, height: 50)
        )
        initialsStackView.addArrangedSubview(companionLabel)
        initialsStackView.alignment = .center
        initialsStackView.distribution = .equalCentering
        initialsStackView.backgroundColor = UIColor(white: 1, alpha: 0.9)
    }

    private func setupCompanionLabel() {
        companionLabel.textAlignment = .center
        companionLabel.font = .systemFont(ofSize: 17, weight: .bold)
    }

    // MARK: - Helpers
    private func handleKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeHandleKeyboardObservers() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }

    private func estimateFrameForTextMessage(text: String) -> CGRect {
        return NSString(string: text).boundingRect(
            with: messageFrameSize,
            options: drawingOptions,
            attributes: convertToOptionalNSAttributedStringKeyDictionary([
                convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)
            ]),
            context: nil
        )
    }

    private func convertToOptionalNSAttributedStringKeyDictionary(
        _ input: [String: Any]?
    ) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in
            (NSAttributedString.Key(rawValue: key), value)
        })
    }

    private func convertFromNSAttributedStringKey(
        _ input: NSAttributedString.Key
    ) -> String {
        return input.rawValue
    }

    // Firebase
    private func fetchMessages() {
        if let userID = Auth.auth().currentUser?.uid {
            databaseReferenceToUserMessages.child(userID).observe(.childAdded) { snapshot in
                let messageID = snapshot.key
                self.databaseReferenceToMessagesCache.child(messageID).observeSingleEvent(of: .value) { snapshot in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let message = Chat(dictionary: dictionary)
                        if message.chatPartnerId() == self.user?.id {
                            self.messages.append(message)
                            DispatchQueue.main.async(execute: {
                                self.collectionView?.reloadData()
                            })
                        }
                    }
                }
            }
        }
    }

    private func sendMessage() {
        let text = inputTextField.text ?? "message"
        let timeInterval = Int(Date().timeIntervalSince1970)

        if !text.isEmpty {
            if let toUserID = user?.id,
               let fromUserID = Auth.auth().currentUser?.uid {
                let values: [String: Any] = [
                    "text": text,
                    "toUserID": toUserID,
                    "fromUserID": fromUserID,
                    "timeInterval": timeInterval
                ]
                saveSenderAndRecipientMessageToDatabase(values: values, fromUserID: fromUserID, toUserID: toUserID)
                inputTextField.text?.removeAll()
            } else {
                present(
                    AlertManager.instance.showAlert(
                        title: "Error",
                        message: "The requested UserID has not found."
                    ), animated: true
                )
            }
        }
    }

    private func saveSenderAndRecipientMessageToDatabase(values: [String: Any], fromUserID: String, toUserID: String) {
        let databaseReferenceToUniqueMessageID = databaseReferenceToMessagesCache.childByAutoId()

        databaseReferenceToUniqueMessageID.updateChildValues(values) { error, _ in
            if error == nil {
                let messageID = databaseReferenceToUniqueMessageID.key
                if let messageID = messageID {
                    self.databaseReferenceToUserMessages.child(fromUserID).updateChildValues([messageID: 1])
                    self.databaseReferenceToUserMessages.child(toUserID).updateChildValues([messageID: 1])
                }
            } else {
                self.showAlertError(error: error)
            }
        }
    }

    private func showAlertError(error: Error?) {
        present(
            AlertManager.instance.showAlertError(error: error),
            animated: true, completion: nil
        )
    }

    // MARK: - Actions
    // MARK: - CollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MessageCell.Constants.messageCell,
            for: indexPath
        ) as? MessageCell else {
            fatalError("DequeueReusableCell failed while casting.")
        }
        let message = messages[indexPath.row]
        cell.messageTextView.text = message.text
        setupColorMessageCell(message: message, cell: cell)
        setupWidthMessageCell(indexPath: indexPath, cell: cell)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        setupHeightMessageCell(indexPath: indexPath)
        return CGSize(width: view.frame.width, height: messageHeight ?? 0)
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }

    // MARK: - Objc methods
    @objc private func sendButtonDidTapped() {
        sendMessage()
    }

    @objc private func handleKeyboardWillShow(notification: Notification) {
        if let chatInputStackViewBottomAnchor = chatInputStackViewBottomAnchor {
            KeyboardManager.instance.getOpenKeyboardFrame(
                notification: notification,
                NSLayoutConstraint: chatInputStackViewBottomAnchor
            )
            collectionView.customContentViewDistanceSafeArea(
                collectionView: collectionView,
                top: 64,
                left: 0,
                right: 0,
                bottom: 384
            )
            collectionView.scrollToLastItem(
                collectionView: collectionView,
                position: .bottom,
                animated: false
            )
        }
        KeyboardManager.instance.getKeyboardAnimationDuration(
            notification: notification, view: collectionView
        )
    }

    @objc private func handleKeyboardWillHide(notification: Notification) {
        if let chatInputStackViewBottomAnchor = chatInputStackViewBottomAnchor {
            KeyboardManager.instance.getHideKeyboardFrame(
                NSLayoutConstraint: chatInputStackViewBottomAnchor
            )
            collectionView.customContentViewDistanceSafeArea(
                collectionView: collectionView,
                top: 64,
                left: 0,
                right: 0,
                bottom: 64
            )
        }
        KeyboardManager.instance.getKeyboardAnimationDuration(
            notification: notification, view: collectionView
        )
    }

    // MARK: - Touch responders
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
