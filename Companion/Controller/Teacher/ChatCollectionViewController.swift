import UIKit
import Firebase

final class ChatCollectionViewController: UICollectionViewController, UITextFieldDelegate {
    // MARK: - Constants
    // MARK: Private
    private let databaseReferenceToMessages = FirebaseManager.instance.databaseReferenceToMessages
    private let databaseReferenceToTeachers = FirebaseManager.instance.databaseReferenceToTeachers
    private let chatInputStackView = UIStackView()
    private let initialsStackView = UIStackView()
    private let sendButton = CustomPlainUIButton(systemName: "paperplane")
    private let inputTextField = UITextField()
    private let companionLabel = UILabel()

    // MARK: - Properties
    var user: User? {
        didSet {
            companionLabel.text = user?.name
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupChatInputContainerView()
        setupInputTextField()
        setupSendButton()
        setupInitialsStackView()
        setupCompanionLabel()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = AppColor.shadowColor
        view.addSubview(chatInputStackView)
        view.addSubview(initialsStackView)
    }

    private func setupChatInputContainerView() {
        chatInputStackView.anchor(
            top: nil,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            bottom: initialsStackView.topAnchor,
            padding: .init(top: 0, left: 12, bottom: 0, right: 12),
            size: .init(width: 0, height: 50)
        )
        chatInputStackView.addArrangedSubview(inputTextField)
        chatInputStackView.addArrangedSubview(sendButton)
        chatInputStackView.alignment = .center
        chatInputStackView.distribution = .equalCentering
    }

    private func setupInputTextField() {
        inputTextField.widthAnchor.constraint(equalTo: chatInputStackView.widthAnchor, multiplier: 0.85).isActive = true
        inputTextField.delegate = self
        inputTextField.placeholder = "Enter message..."
    }

    private func setupSendButton() {
        sendButton.addTarget(self, action: #selector(sendButtonDidTapped), for: .touchUpInside)
    }

    private func setupInitialsStackView() {
        initialsStackView.anchor(
            top: chatInputStackView.bottomAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            size: .init(width: 0, height: 50)
        )
        initialsStackView.addArrangedSubview(companionLabel)
        initialsStackView.alignment = .center
        initialsStackView.distribution = .equalCentering
    }

    private func setupCompanionLabel() {
        companionLabel.textAlignment = .center
        companionLabel.font = .systemFont(ofSize: 17, weight: .bold)
    }

    // MARK: - Helpers
    private func sendMessage() {
        let uniqueKeyChildMessage = databaseReferenceToMessages.childByAutoId()
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
                uniqueKeyChildMessage.updateChildValues(values)
                inputTextField.text = ""
            } else {
                present(
                    AlertManager.instance.showAlert(
                        title: "Error",
                        message: "The requested UserID was not found."
                    ), animated: true
                )
            }
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
