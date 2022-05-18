import UIKit
import Firebase
import FirebaseAuth

final class MessengerTableViewController: UITableViewController {
    // MARK: - Constants
    private let databaseReferenceToTeachers = FirebaseManager.instance.databaseReferenceToTeachers
    private let databaseReferenceToMessages = FirebaseManager.instance.databaseReferenceToMessages
    private let personsImage = UIImage(systemName: "person.badge.plus")
    private let usersBarButton = UIBarButtonItem()

    // MARK: - Properties
    private var handleAuthDidChangeListener: AuthStateDidChangeListenerHandle?
    private var messages: [Message] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupNavigationController()
        setupUsersBarButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        handleAuthListener()
        observeMessages()
    }

    override func viewWillDisappear(_ animated: Bool) {
        removeHandleAuthListener()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = AppColor.shadowColor
    }

    private func setupTableView() {
        tableView.rowHeight = 80
        tableView.register(
            MessageCell.self,
            forCellReuseIdentifier: Message.Constants.messageCell
        )
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
        let listOfUsersTableViewController = ListOfUsersTableViewController()
        present(listOfUsersTableViewController, animated: true)
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

    private func observeMessages() {
        databaseReferenceToMessages.observe(.childAdded, with: { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Message.Constants.messageCell,
            for: indexPath
        ) as? MessageCell else {
            fatalError("DequeueReusableCell failed while casting.")
        }
        cell.selectionStyle = .none
        cell.backgroundColor = AppColor.shadowColor
        cell.configure(using: messages[indexPath.row])

        return cell
    }

    // MARK: - Actions
    // MARK: Objc Methods
    @objc private func usersButtonDidTapped() {
        openUsersTableViewController()
    }
}
