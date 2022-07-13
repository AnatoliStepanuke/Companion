import UIKit
import Firebase
import FirebaseDatabase

final class LoginViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Constants
    // MARK: - Private
    private let defaults = UserDefaults.standard
    private let mainStackView = UIStackView()
    private let emailTextField = CustomAuthUITextField(
        placeholderText: "Email",
        autocapitalizationType: .none,
        keyboardType: .emailAddress
    )
    private let passwordTextField = CustomAuthUITextField(
        placeholderText: "Password",
        autocapitalizationType: .sentences,
        keyboardType: .default
    )
    private let loginButton = CustomRoundedUIButton(title: "Login", fontColor: AppColor.blackColor)
    private let passwordRecoveryButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupMainStackView()
        setupLoginButton()
        setupPasswordRecoveryButton()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = AppColor.shadowColor
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
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(loginButton)
        mainStackView.addArrangedSubview(passwordRecoveryButton)
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func setupLoginButton() {
        loginButton.addTarget(self, action: #selector(loginButtonDidTapped), for: .touchUpInside)
    }

    private func setupPasswordRecoveryButton() {
        passwordRecoveryButton.setTitle("Forgot your password?", for: .normal)
        passwordRecoveryButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        passwordRecoveryButton.tintColor = .red
        passwordRecoveryButton.addTarget(self, action: #selector(passwordRecoveryButtonDidTapped), for: .touchUpInside)
    }

    // MARK: - Helpers
    private func switchToNextTextField(_ textField: UITextField) {
        switch textField {
        case emailTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: makeUserLogin()
        default: emailTextField.resignFirstResponder()
        }
    }

    // OpenVC
    private func openPasswordRecoveryViewController() {
        let passwordRecoveryViewController = PasswordRecoveryViewController()
        present(passwordRecoveryViewController, animated: true, completion: nil)
    }

    private func openAndSaveTabBarViewController(defaultsforKey: String, identifier: String) {
        let pvc = self.presentingViewController
        defaults.set(true, forKey: defaultsforKey)
        dismiss(animated: true, completion: {
            pvc?.present(
                NavigationStackManager.instance.modalPresentFullScreenTabBarViewController(
                    identifier: identifier
                ), animated: true, completion: nil
            )
        })
    }

    // Firebase
    // Login
    private func userLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error == nil {
                self.openAndSaveTabBarViewController(
                    defaultsforKey: UserDefaults.Keys.isUserLoggedIn,
                    identifier: UIStoryboard.Keys.mainTabBarController
                )
            } else {
                self.presentAlertError(error: error)
            }
        }
    }

    private func makeUserLogin() {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "userEmail"
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "userPassword"

        if !email.isEmpty && !password.isEmpty {
            userLogin(email: email, password: password)
        } else {
            presentAlertEmptyFields()
        }

    }

    // Show alert
    private func presentAlertError(error: Error?) {
        present(
            AlertManager.instance.showAlertError(error: error),
            animated: true, completion: nil
        )
    }

    private func presentAlertEmptyFields() {
        present(
            AlertManager.instance.showAlertEmptyFields(),
            animated: true, completion: nil
        )
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchToNextTextField(textField)
        return true
    }

    // MARK: - Actions
    // MARK: Objc Methods
    @objc private func loginButtonDidTapped() {
        makeUserLogin()
    }

    @objc private func passwordRecoveryButtonDidTapped() {
        openPasswordRecoveryViewController()
    }

    // MARK: - Touch responders
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
