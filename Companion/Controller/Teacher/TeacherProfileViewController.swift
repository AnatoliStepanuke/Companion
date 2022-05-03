import UIKit
import FirebaseAuth

final class TeacherProfileViewController: UIViewController {
    // MARK: - Constants
    // MARK: - Private
    private let defaults = UserDefaults.standard
    private let mainStackView = UIStackView()
    private let signoutButton = UIButton()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupMainStackView()
        setupSignoutButton()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = AppColor.shadowColor
        view.addSubview(mainStackView)
    }

    private func setupNavigationController() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

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
        mainStackView.addArrangedSubview(signoutButton)
    }

    private func setupSignoutButton() {
        signoutButton.heightAnchor.constraint(equalToConstant: 72).isActive = true
        signoutButton.configuration = .bordered()
        signoutButton.configuration?.title = "Sign out"
        signoutButton.configuration?.subtitle = "Return to auth screen"
        signoutButton.configuration?.baseForegroundColor = .black
        signoutButton.configuration?.image = UIImage(systemName: "person.fill.xmark")
        signoutButton.configuration?.imagePadding = 36
        signoutButton.addTarget(self, action: #selector(signoutButtonDidTapped), for: .touchUpInside)
    }

    // MARK: - Helpers
    private func showAlertSignout(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sign out", style: .destructive, handler: { _ in
            self.userSignout()
            self.showStartViewController()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }

    private func showStartViewController() {
        dismiss(animated: true, completion: {
            self.present(
                NavigationStackManager.instance.modalPresentFullScreenViewController(
                    identifier: "StartViewController"
                ), animated: true, completion: nil
            )
        })
    }

    // Firebase
    private func userSignout() {
        do {
            try Auth.auth().signOut()
            defaults.set(false, forKey: UserDefaults.Keys.isTeacherSignedIn)
        } catch let signoutError as NSError {
            print("Sign out error - \(signoutError)")
        }
    }

    // MARK: - Actions
    // MARK: Objc Methods
    @objc private func signoutButtonDidTapped() {
        showAlertSignout(title: "Do you really want to sign out?", message: "This action is can't be reverted")
    }
}
