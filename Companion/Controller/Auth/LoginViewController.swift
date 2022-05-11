import UIKit
import Firebase
import FirebaseDatabase

final class LoginViewController: UIViewController {
    // MARK: - Constants
    // MARK: - Private
    private let defaults = UserDefaults.standard
    private let mainStackView = UIStackView()
    private let typeOfUserLabel = CustomUILabel(text: "Login as:")
    private let typesOfUsersSegmentedControl = UISegmentedControl()
    private let emailTextField = CustomAuthtUITextField(placeholderText: "Email")
    private let passwordTextField = CustomAuthtUITextField(placeholderText: "Password")
    private let loginButton = CustomRoundedUIButton(title: "Login", fontColor: AppColor.whiteColor)
    private let passwordRecoveryButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupMainStackView()
        setupTypesOfUsersSegmentedControl()
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
        mainStackView.addArrangedSubview(typeOfUserLabel)
        mainStackView.addArrangedSubview(typesOfUsersSegmentedControl)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(loginButton)
        mainStackView.addArrangedSubview(passwordRecoveryButton)
    }

    private func setupTypesOfUsersSegmentedControl() {
        typesOfUsersSegmentedControl.addItems(items: [
            "Student",
            "Teacher"
        ])
        typesOfUsersSegmentedControl.selectedSegmentIndex = 0
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
    private func firebaseStudentSignin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error == nil {
                self.openAndSaveTabBarViewController(
                    defaultsforKey: UserDefaults.Keys.isStudentSignedIn,
                    identifier: "StudentTabBarController"
                )
            } else {
                self.presentAlertError(error: error)
            }
        }
    }

    private func firebaseTeacherSignin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error == nil {
                self.openAndSaveTabBarViewController(
                    defaultsforKey: UserDefaults.Keys.isTeacherSignedIn,
                    identifier: "TeacherTabBarController"
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
            switch typesOfUsersSegmentedControl.selectedSegmentIndex {
            case 0: firebaseStudentSignin(email: email, password: password)
            case 1: firebaseTeacherSignin(email: email, password: password)
            default: print("Login: Something going bad wrong")
            }
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
