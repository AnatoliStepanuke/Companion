import UIKit
import FirebaseAuth

final class HomeViewController: UIViewController {
    // MARK: - Properties
    private var handleAuthDidChangeListener: AuthStateDidChangeListenerHandle?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
    }

    override func viewWillAppear(_ animated: Bool) {
        handleAuthListener()
    }

    override func viewWillDisappear(_ animated: Bool) {
        removeHandleAuthListener()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = AppColor.shadowColor
    }

    private func setupNavigationController() {
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Helpers
    private func openAuthViewController() {
        let startViewController = StartViewController()
        self.view.window?.rootViewController = startViewController
        self.view.window?.makeKeyAndVisible()
    }

    // Firebase
    private func handleAuthListener() {
        handleAuthDidChangeListener = Auth.auth().addStateDidChangeListener { _, user in
            if user == nil {
                self.openAuthViewController()
            }
        }
    }

    private func removeHandleAuthListener() {
        guard let handle = handleAuthDidChangeListener else {
            fatalError("")
        }
        Auth.auth().removeStateDidChangeListener(handle)
    }
}
