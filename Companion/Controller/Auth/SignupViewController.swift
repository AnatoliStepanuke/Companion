import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

final class SignupViewController: UIViewController,
    UITextFieldDelegate,
    UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // MARK: - Constants
    // MARK: - Private
    // UserDefaults
    private let defaults = UserDefaults.standard

    // UIStackView
    private let mainStackView = UIStackView()

    // Firebase
    private let databaseReferenceToStudents = FirebaseManager.instance.databaseReferenceToStudents
    private let databaseReferenceToTeachers = FirebaseManager.instance.databaseReferenceToTeachers
    private let storageReferenceToStudentsImages = FirebaseManager.instance.storageReferenceToStudentsImages
    private let storageReferenceToTeachersImages = FirebaseManager.instance.storageReferenceToTeachersImages

    // UIImage
    private let profileImageView = CustomProfileUIImageViewWithConfig(
        systemName: "person.crop.circle.badge.plus",
        height: 125,
        width: 125,
        pointSize: 100,
        weight: .ultraLight,
        scale: .medium
    )
    private let pickerController = UIImagePickerController()

    // UITextFields
    private let nameTextField = CustomAuthUITextField(
        placeholderText: "Name",
        autocapitalizationType: .words,
        keyboardType: .default
    )
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

    // UIButton
    private let signupButton = CustomRoundedUIButton(
        title: "Sign up",
        buttonColor: AppColor.buttonColor,
        fontColor: AppColor.fontColor,
        roundingRadius: 16,
        buttonHeight: 36
    )

    // MARK: - Properties
    // MARK: - Private
    private var selectedImageFromPicker: UIImage?
    private var absoluteStringURL: String = " "

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupProfileImageView()
        setupMainStackView()
        setupSignupButton()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = AppColor.shadowColor
        view.addSubview(profileImageView)
        view.addSubview(mainStackView)
    }

    // MARK: setupProfileImageView
    private func setupProfileImageView() {
        profileImageView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: nil,
            trailing: nil,
            bottom: mainStackView.topAnchor,
            padding: .init(top: 36, left: 0, bottom: 12, right: 0)
        )
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.center = view.center
        profileImageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(profileImageViewDidTapped)
            )
        )
    }

    // MARK: setupMainStackView
    private func setupMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.anchor(
            top: profileImageView.bottomAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            bottom: nil,
            padding: .init(top: 12, left: 12, bottom: 0, right: 12)
        )
        mainStackView.alignment = .fill
        mainStackView.distribution = .equalSpacing
        mainStackView.spacing = 24
        mainStackView.addArrangedSubview(nameTextField)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(signupButton)
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func setupSignupButton() {
        signupButton.addTarget(self, action: #selector(signupButtonDidTapped), for: .touchUpInside)
    }

    // MARK: - Helpers
    private func switchToNextTextField(_ textField: UITextField) {
        switch textField {
        case nameTextField: emailTextField.becomeFirstResponder()
        case emailTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: makeUserSignup()
        default: emailTextField.resignFirstResponder()
        }
    }

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

    // Picker Controller
    private func openPickerController() {
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let editedImage = info[
            UIImagePickerController.InfoKey(
                rawValue: "UIImagePickerControllerEditedImage"
            )
        ] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[
            UIImagePickerController.InfoKey(
                rawValue: "UIImagePickerControllerOriginalImage"
            )
        ] as? UIImage {
            selectedImageFromPicker = originalImage
        }

        if let selectedImageFromPicker = selectedImageFromPicker {
            profileImageView.image = selectedImageFromPicker
        }

        dismiss(animated: true, completion: nil)

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // Firebase
    // Saving
    private func saveUserToDatabase(
        name: String,
        email: String,
        userID: String,
        databaseReference: DatabaseReference,
        absoluteStringURL: String
    ) {
        databaseReference.child(userID).updateChildValues([
            "name": name,
            "email": email,
            "profileImageURL": absoluteStringURL
        ])
    }

    private func saveUserToStorageAndDatabase(
        name: String,
        email: String,
        userID: String,
        databaseReference: DatabaseReference,
        storageReference: StorageReference
    ) {
        if let profileImage = profileImageView.image,
           let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
            storageReference.putData(uploadData, metadata: nil) { _, error in
                if error == nil {
                    storageReference.downloadURL { url, error in
                        if error == nil {
                            if let url = url {
                                self.saveUserToDatabase(
                                    name: name,
                                    email: email,
                                    userID: userID,
                                    databaseReference: databaseReference,
                                    absoluteStringURL: url.absoluteString
                                )
                            }
                        } else {
                            self.showAlertError(error: error)
                        }
                    }
                } else {
                    self.showAlertError(error: error)
                }
            }
        }
    }

    // Creating user
    private func createAndSaveStudent(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error == nil {
                if let result = result {
                    self.saveUserToStorageAndDatabase(
                        name: name,
                        email: email,
                        userID: result.user.uid,
                        databaseReference: self.databaseReferenceToStudents,
                        storageReference: self.storageReferenceToStudentsImages
                    )
                    self.openAndSaveTabBarViewController(
                        defaultsforKey: UserDefaults.Keys.isUserLoggedIn,
                        identifier: UIStoryboard.Keys.mainTabBarController
                    )
                }
            } else {
                self.showAlertError(error: error)
            }
        }
    }

    private func createAndSaveTeacher(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error == nil {
                if let result = result {
                    self.saveUserToStorageAndDatabase(
                        name: name,
                        email: email,
                        userID: result.user.uid,
                        databaseReference: self.databaseReferenceToTeachers,
                        storageReference: self.storageReferenceToTeachersImages
                    )
                    self.openAndSaveTabBarViewController(
                        defaultsforKey: UserDefaults.Keys.isUserLoggedIn,
                        identifier: UIStoryboard.Keys.mainTabBarController
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
                title: "Attention",
                message: "Choose a client for sign in:\n In future your data can't be rewrited",
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
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sign in as a student", style: .default, handler: { _ in
            self.createAndSaveStudent(
                name: name,
                email: email,
                password: password
            )
        }))
        alert.addAction(UIAlertAction(title: "Sign in as a teacher", style: .default, handler: { _ in
            self.createAndSaveTeacher(
                name: name,
                email: email,
                password: password
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

    @objc private func profileImageViewDidTapped() {
        openPickerController()
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchToNextTextField(textField)
        return true
    }

    // MARK: - Touch responders
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
