import UIKit
import FirebaseAuth
import FirebaseDatabase

final class StartViewController: UIViewController {
    // MARK: - Constants
    // MARK: - Private
    private let defaults = UserDefaults.standard
    private let companionLabel = UILabel()
    private let buttonsStackView = UIStackView()
    private let loginButton = CustomRoundedUIButton(
        title: "Log in",
        buttonColor: AppColor.buttonColor,
        fontColor: AppColor.fontColor,
        roundingRadius: 16,
        buttonHeight: 36
    )
    private let signupButton = CustomRoundedUIButton(
        title: "Sign up",
        buttonColor: AppColor.buttonColor,
        fontColor: AppColor.fontColor,
        roundingRadius: 16,
        buttonHeight: 36
    )

    // MARK: - Properties
    private var handleAuthDidChangeListener: AuthStateDidChangeListenerHandle?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCompanionLabel()
        setupButtonsStackView()
        setupLoginButton()
        setupSignupButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        isUserSignedIn()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = AppColor.shadowColor
        view.addSubview(companionLabel)
        view.addSubview(buttonsStackView)
    }

    private func setupCompanionLabel() {
        companionLabel.text = "Companion"
        companionLabel.textAlignment = .center
        companionLabel.font = .boldSystemFont(ofSize: 52)
        companionLabel.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: buttonsStackView.topAnchor
        )
    }

    // MARK: setupButtonsStackView
    private func setupButtonsStackView() {
        buttonsStackView.axis = .vertical
        buttonsStackView.anchor(
            top: companionLabel.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.bottomAnchor,
            padding: .init(top: 0, left: 12, bottom: 36, right: 12)
        )
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 24
        buttonsStackView.addArrangedSubview(loginButton)
        buttonsStackView.addArrangedSubview(signupButton)
    }

    private func setupLoginButton() {
        loginButton.addTarget(self, action: #selector(loginButtonDidTapped), for: .touchUpInside)
    }

    private func setupSignupButton() {
        signupButton.addTarget(self, action: #selector(signupButtonDidTapped), for: .touchUpInside)
    }

    // MARK: - Helpers
    private func openLoginViewController() {
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true, completion: nil)
    }

    private func openSignupViewController() {
        let signupViewController = SignupViewController()
        present(signupViewController, animated: true, completion: nil)
    }

    private func isUserSignedIn() {
        if defaults.bool(forKey: UserDefaults.Keys.isUserLoggedIn) {
            present(
                NavigationStackManager.instance.modalPresentFullScreenTabBarViewController(
                    identifier: UIStoryboard.Keys.mainTabBarController
                ),
                animated: true
            )
        }
    }

    // MARK: - Actions
    // MARK: Objc Methods
    @objc private func loginButtonDidTapped() {
        openLoginViewController()
    }

    @objc private func signupButtonDidTapped() {
        openSignupViewController()
    }
}
