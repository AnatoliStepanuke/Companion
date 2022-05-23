import UIKit
import Firebase
import FirebaseAuth

final class MessengerTableViewController: UITableViewController {
    // MARK: - Constants
    private let databaseReferenceToTeachers = FirebaseManager.instance.databaseReferenceToTeachers
    private let databaseReferenceToStudents = FirebaseManager.instance.databaseReferenceToStudents
    private let databaseReferenceToMessages = FirebaseManager.instance.databaseReferenceToMessagesCache
    private let databaseReferenceToUserMessages = FirebaseManager.instance.databaseReferenceToMessagesByPerUser
    private let personsImage = UIImage(systemName: "person.badge.plus")
    private let usersBarButton = UIBarButtonItem()

    // MARK: - Properties
    private var handleAuthDidChangeListener: AuthStateDidChangeListenerHandle?
    private var chats: [Chat] = []
    private var chatsDictionary = [String: Chat]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupUsersBarButton()
        setupTableView()
        fetchChats()
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

    private func setupTableView() {
        tableView.rowHeight = 80
        tableView.register(
            ChatCell.self,
            forCellReuseIdentifier: Chat.Constants.messageCell
        )
    }

    // MARK: - Helpers
    private func sortChatsByUserID(dictionary: [String: AnyObject]) {
        let chat = Chat(dictionary: dictionary)
        if let messageToUserID = chat.toUserID {
            chatsDictionary[messageToUserID] = chat
        }
        chats = Array(chatsDictionary.values)
    }

    private func sortChatsbByTimeInterval() {
        chats.sort(by: { newMessage, oldMessage -> Bool in
            guard let newMessage = newMessage.timeInterval else {
                fatalError("can't return timeInterval")
            }
            guard let oldMessage = oldMessage.timeInterval else {
                fatalError("can't return timeInterval")
            }

            return newMessage.intValue > oldMessage.intValue
        })
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
        self.databaseReferenceToStudents.child(userID).observeSingleEvent(of: .value) { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let userName = dictionary["name"] as? String {
                    self.navigationItem.title = "Hi, \(userName)"
                }
            }
        }

    }

    private func fetchChats() {
        if let userID = Auth.auth().currentUser?.uid {
            databaseReferenceToUserMessages.child(userID).observe(.childAdded) { snapshot in
                let messageID = snapshot.key
                self.databaseReferenceToMessages.child(messageID).observeSingleEvent(of: .value) { snapshot in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        self.sortChatsByUserID(dictionary: dictionary)
                        self.sortChatsbByTimeInterval()
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                        })
                    }
                }
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Chat.Constants.messageCell,
            for: indexPath
        ) as? ChatCell else {
            fatalError("DequeueReusableCell failed while casting.")
        }
        cell.selectionStyle = .none
        cell.backgroundColor = AppColor.shadowColor
        cell.configure(using: chats[indexPath.row])

        return cell
    }

    // MARK: - Actions
    private func openAuthViewController() {
        let startViewController = StartViewController()
        view.window?.rootViewController = startViewController
        view.window?.makeKeyAndVisible()
    }

    private func openUsersTableViewController() {
        let listOfUsersTableViewController = ListOfUsersTableViewController()
        present(listOfUsersTableViewController, animated: true)
    }

    // MARK: Objc Methods
    @objc private func usersButtonDidTapped() {
        openUsersTableViewController()
    }
}
