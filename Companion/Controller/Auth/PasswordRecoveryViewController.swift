import UIKit
import FirebaseAuth

final class PasswordRecoveryViewController: UIViewController {
    // MARK: - Constants
    // MARK: - Private
    private let mainStackView = UIStackView()
    private let passwordRecoveryLabel = CustomUILabel(text: "Enter email below to send link")
    private let emailTextField = CustomTransparentUITextField(placeholderText: "Email")
    private let sendEmailButton = CustomRoundedUIButton(title: "Send", fontColor: .systemRed)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupMainStackView()
        setupSendEmailButton()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = AppColor.backgrounColor
        view.addSubview(mainStackView)
    }

    // MARK: setupTextFieldsStackView
    private func setupMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            bottom: nil,
            padding: .init(top: 36, left: 12, bottom: 0, right: 12)
        )
        mainStackView.alignment = .fill
        mainStackView.distribution = .equalSpacing
        mainStackView.spacing = 24
        mainStackView.addArrangedSubview(passwordRecoveryLabel)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(sendEmailButton)
    }

    private func setupSendEmailButton() {
        sendEmailButton.addTarget(self, action: #selector(sendEmailButtonDidTapped), for: .touchUpInside)
    }

    // MARK: - Helpers
    // Firebase
    // Send recovery link
    private func firebaseSendPasswordReset(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                self.present(
                    self.showAlertWithDismissingViewController(
                        title: "Recovery sended",
                        message: "Check your email"
                    ),
                    animated: true, completion: nil
                )
            } else {
                self.present(
                    AlertManager.instance.showAlertError(error: error),
                    animated: true, completion: nil
                )
            }
        }
    }

    private func makeSendEmail() {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "userEmail"

        if !email.isEmpty {
            firebaseSendPasswordReset(email: email)
        } else {
            present(
                AlertManager.instance.showAlertEmptyFields(),
                animated: true, completion: nil
            )
        }
    }

    // Show alert
    func showAlertWithDismissingViewController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        }))

        return alert
    }

    // MARK: - Actions
    // MARK: Objc Methods
    @objc private func sendEmailButtonDidTapped() {
        makeSendEmail()
    }

    // MARK: - Touch responders
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
