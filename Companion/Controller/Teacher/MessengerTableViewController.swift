import UIKit
import Firebase
import FirebaseAuth

final class MessengerTableViewController: UITableViewController {
    // MARK: - Constants
    private let databaseReferenceToTeachers = FirebaseManager.instance.databaseReferenceToTeachers
    private let personsImage = UIImage(systemName: "person.badge.plus")
    private let usersBarButton = UIBarButtonItem()

    // MARK: - Properties
    private var handleAuthDidChangeListener: AuthStateDidChangeListenerHandle?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupUsersBarButton()
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
        title = "Messenger"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setRightBarButton(usersBarButton, animated: true)
    }

    private func setupUsersBarButton() {
        usersBarButton.image = personsImage
        usersBarButton.tintColor = AppColor.blackColor
        usersBarButton.target = self
        usersBarButton.action = #selector(usersButtonDidTapped)
    }

    // MARK: - Helpers
    private func openAuthViewController() {
        let startViewController = StartViewController()
        view.window?.rootViewController = startViewController
        view.window?.makeKeyAndVisible()
    }

    private func openUsersTableViewController() {
        let usersTableViewController = UsersTableViewController()
        present(
            NavigationStackManager.instance.modalPresentFullScreenViewController(
                viewController: usersTableViewController
            ), animated: true, completion: nil
        )
    }

    // Firebase
    private func handleAuthListener() {
        handleAuthDidChangeListener = Auth.auth().addStateDidChangeListener { _, user in
            if user == nil {
                self.openAuthViewController()
            } else {
                if let user = user {
                    self.displayUserNameNavigationController(userID: user.uid)
                }
            }
        }
    }

    private func removeHandleAuthListener() {
        guard let handle = handleAuthDidChangeListener else {
            fatalError("")
        }
        Auth.auth().removeStateDidChangeListener(handle)
    }

    private func displayUserNameNavigationController(userID: String) {
        self.databaseReferenceToTeachers.child(userID).observeSingleEvent(of: .value) { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let userName = dictionary["name"] as? String {
                    self.navigationItem.title = "Hi, \(userName)"
                }
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    // MARK: - Actions
    // MARK: Objc Methods
    @objc private func usersButtonDidTapped() {
        openUsersTableViewController()
    }
}
