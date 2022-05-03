import UIKit
import Firebase
import FirebaseDatabase

final class SignupViewController: UIViewController {
    // MARK: - Constants
    // MARK: - Private
    private let defaults = UserDefaults.standard
    private let mainStackView = UIStackView()
    private let databaseReferenceToStudents = Database.database().reference().child("students")
    private let databaseReferenceToTeachers = Database.database().reference().child("teachers")
    private let nameTextField = CustomTransparentUITextField(placeholderText: "Name")
    private let emailTextField = CustomTransparentUITextField(placeholderText: "Email")
    private let passwordTextField = CustomTransparentUITextField(placeholderText: "Password")
    private let signupButton = CustomRoundedUIButton(title: "Sign up", fontColor: .black)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupMainStackView()
        setupSignupButton()
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
        mainStackView.addArrangedSubview(nameTextField)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(signupButton)
    }

    private func setupSignupButton() {
        signupButton.addTarget(self, action: #selector(signupButtonDidTapped), for: .touchUpInside)
    }

    // MARK: - Helpers
    // OpenVC
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
    // Saving
    private func saveUserToDatabase(name: String, email: String, userID: String, reference: DatabaseReference) {
        reference.child(userID).updateChildValues([
            "name": name,
            "email": email
        ])
    }

    // Creating user
    private func createAndSaveStudent(name: String, email: String, password: String, reference: DatabaseReference) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error == nil {
                if let result = result {
                    self.saveUserToDatabase(name: name, email: email, userID: result.user.uid, reference: reference)
                    self.openAndSaveTabBarViewController(
                        defaultsforKey: UserDefaults.Keys.isStudentSignedIn,
                        identifier: "StudentTabBarController"
                    )
                }
            } else {
                self.showAlertError(error: error)
            }
        }
    }

    private func createAndSaveTeacher(name: String, email: String, password: String, reference: DatabaseReference) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error == nil {
                if let result = result {
                    self.saveUserToDatabase(name: name, email: email, userID: result.user.uid, reference: reference)
                    self.openAndSaveTabBarViewController(
                        defaultsforKey: UserDefaults.Keys.isTeacherSignedIn,
                        identifier: "TeacherTabBarController"
                    )
                }
            } else {
                self.showAlertError(error: error)
            }
        }
    }

    private func makeUserSignup() {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "userName"
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "userEmail"
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "userPassword"

        if !name.isEmpty && !email.isEmpty && !password.isEmpty {
            showAlertSignin(
                title: "Which client to enter?",
                message: "You can change client type during re-login",
                name: name,
                email: email,
                password: password
            )
        } else {
            showAlertEmptyFields()
        }
    }

    // Show alert
    private func showAlertSignin(title: String, message: String, name: String, email: String, password: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sign in now as a student", style: .default, handler: { _ in
            self.createAndSaveStudent(
                name: name,
                email: email,
                password: password,
                reference: self.databaseReferenceToStudents
            )
        }))
        alert.addAction(UIAlertAction(title: "Sign in now as a teacher", style: .default, handler: { _ in
            self.createAndSaveTeacher(
                name: name,
                email: email,
                password: password,
                reference: self.databaseReferenceToTeachers
            )
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }

    private func showAlertError(error: Error?) {
        present(
            AlertManager.instance.showAlertError(error: error),
            animated: true, completion: nil
        )
    }

    private func showAlertEmptyFields() {
        present(
            AlertManager.instance.showAlertEmptyFields(),
            animated: true, completion: nil
        )
    }

    // MARK: - Actions
    // MARK: Objc Methods
    @objc private func signupButtonDidTapped() {
        makeUserSignup()
    }

    // MARK: - Touch responders
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
