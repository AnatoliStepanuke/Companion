import UIKit
import Firebase

final class ChatCollectionViewController: UICollectionViewController, UITextFieldDelegate {
    // MARK: - Constants
    // MARK: Private
    private let databaseReferenceToMessages = FirebaseManager.instance.databaseReferenceToMessages
    private let chatInputContainerView = UIStackView()
    private let sendButton = CustomPlainUIButton(systemName: "paperplane")
    private let inputTextField = UITextField()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupChatInputContainerView()
        setupInputTextField()
        setupSendButton()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = AppColor.shadowColor
        view.addSubview(chatInputContainerView)
    }

    private func setupNavigationController() {
        title = "Chat"
    }

    private func setupChatInputContainerView() {
        chatInputContainerView.anchor(
            top: nil,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            padding: .init(top: 0, left: 12, bottom: 0, right: 12),
            size: .init(width: 0, height: 50)
        )
        chatInputContainerView.addArrangedSubview(inputTextField)
        chatInputContainerView.addArrangedSubview(sendButton)
        chatInputContainerView.alignment = .center
        chatInputContainerView.distribution = .equalCentering
    }

    private func setupInputTextField() {
        inputTextField.delegate = self
        inputTextField.placeholder = "Enter message..."
    }

    private func setupSendButton() {
        sendButton.addTarget(self, action: #selector(sendButtonDidTapped), for: .touchUpInside)
    }

    // MARK: - Helpers
    private func sendMessage() {
        let uniqueKeyChildMessage = databaseReferenceToMessages.childByAutoId()
        let text = inputTextField.text ?? "message"

        if !text.isEmpty {
            let values = ["text": inputTextField.text!]
            uniqueKeyChildMessage.updateChildValues(values)
            inputTextField.text = ""
        }

    }

    // MARK: - Actions
    // MARK: Objc Methods
    @objc private func sendButtonDidTapped() {
        sendMessage()
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
