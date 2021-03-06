import UIKit
import Firebase
import FirebaseAuth

final class MessengerTableViewController: UITableViewController {
    // MARK: - Constants
    // UIImage
    private let personsImage = UIImage(systemName: "person.badge.plus")

    // UIBarButtonItem
    private let usersBarButton = UIBarButtonItem()

    // Firebase
    private let databaseReferenceToTeachers = FirebaseManager.instance.databaseReferenceToTeachers
    private let databaseReferenceToStudents = FirebaseManager.instance.databaseReferenceToStudents
    private let databaseReferenceToMessagesCache = FirebaseManager.instance.databaseReferenceToMessagesCache
    private let databaseReferenceToUserMessages = FirebaseManager.instance.databaseReferenceToMessagesByPerUser

    // MARK: - Properties
    private var handleAuthDidChangeListener: AuthStateDidChangeListenerHandle?
    private var chats: [Chat] = []
    private var chatsDictionary = [String: Chat]()
    private var timer: Timer?

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
            forCellReuseIdentifier: Chat.Constants.chatCell
        )
    }

    // MARK: - Helpers
    private func loadDictionaryByPartners(dictionary: [String: AnyObject]) {
        let chat = Chat(dictionary: dictionary)
        if let chatPartnerID = chat.chatPartnerId() {
            chatsDictionary[chatPartnerID] = chat
        }
    }

    private func sortChatsbByTimeInterval() {
        chats = Array(chatsDictionary.values)
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

    private func reloadTableViewWithTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(self.handleReloadTable),
            userInfo: nil,
            repeats: false
        )
    }

    // Firebase
    private func handleAuthListener() {
        handleAuthDidChangeListener = Auth.auth().addStateDidChangeListener { _, user in
            if user == nil {
                self.openAuthViewController()
            } else {
                if let user = user {
                    self.displayUserNameNavigationController(
                        databaseRef: self.databaseReferenceToTeachers,
                        userID: user.uid
                    )
                    self.displayUserNameNavigationController(
                        databaseRef: self.databaseReferenceToStudents,
                        userID: user.uid
                    )
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

    private func displayUserNameNavigationController(databaseRef: DatabaseReference, userID: String) {
        databaseRef.child(userID).observeSingleEvent(of: .value) { snapshot in
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
                let partnerID = snapshot.key
                self.databaseReferenceToUserMessages
                    .child(userID)
                    .child(partnerID)
                    .observe( .childAdded) { snapshot in
                    let messageID = snapshot.key
                    self.databaseReferenceToMessagesCache.child(messageID).observeSingleEvent(of: .value) { snapshot in
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            self.loadDictionaryByPartners(dictionary: dictionary)
                            self.sortChatsbByTimeInterval()
                            self.reloadTableViewWithTimer()
                        }
                    }
                }
            }
        }
    }

    private func deleteChat(chat: Chat) {
        if let userID = Auth.auth().currentUser?.uid {
            if let chatPartnerID = chat.chatPartnerId() {
                FirebaseManager.instance.databaseReferenceToMessagesByPerUser
                    .child(userID)
                    .child(chatPartnerID)
                    .removeValue { error, _ in
                        if error == nil {
                            self.chatsDictionary.removeValue(forKey: chatPartnerID)
                            self.reloadTableViewWithTimer()
                        } else {
                            self.showAlertError(error: error)
                        }
                    }
            }
        }
    }

    private func deleteChatForPartner(chat: Chat) {
        if let userID = Auth.auth().currentUser?.uid {
            if let chatPartnerID = chat.chatPartnerId() {
                FirebaseManager.instance.databaseReferenceToMessagesByPerUser
                    .child(chatPartnerID)
                    .child(userID)
                    .removeValue { error, _ in
                        if error == nil {
                            self.chatsDictionary.removeValue(forKey: userID)
                            self.reloadTableViewWithTimer()
                        } else {
                            self.showAlertError(error: error)
                        }
                    }
            }
        }
    }

    // Show alert
    private func showAlertError(error: Error?) {
        present(
            AlertManager.instance.showAlertError(error: error),
            animated: true, completion: nil
        )
    }

    private func showAlertChatDeleting(title: String?, message: String?, chat: Chat) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
            title: "Delete only for me",
            style: .destructive,
            handler: { _ in
                self.deleteChat(chat: chat)
            }
        ))
        alert.addAction(UIAlertAction(
            title: "Delete for me and for companion",
            style: .destructive,
            handler: { _ in
                self.deleteChat(chat: chat)
                self.deleteChatForPartner(chat: chat)
            }
        ))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Chat.Constants.chatCell,
            for: indexPath
        ) as? ChatCell else {
            fatalError("DequeueReusableCell failed while casting.")
        }
        cell.selectionStyle = .none
        cell.backgroundColor = AppColor.shadowColor
        cell.configure(using: chats[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = self.chats[indexPath.row]
        if let chatPartnerID = chat.chatPartnerId() {
            openChatWithPartner(
                databaseRef: databaseReferenceToTeachers,
                chatPartnerID: chatPartnerID,
                indexPath: indexPath
            )
            openChatWithPartner(
                databaseRef: databaseReferenceToStudents,
                chatPartnerID: chatPartnerID,
                indexPath: indexPath
            )
        }
    }

    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete",
            handler: { (_:UIContextualAction, _:UIView, _:(Bool) -> Void) in
                let chat = self.chats[indexPath.row]
                self.showAlertChatDeleting(
                    title: "Attention",
                    message: "Are you sure want to delete the chat?",
                    chat: chat
                )
            }
        )
        return UISwipeActionsConfiguration(actions: [deleteAction])
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

    private func openChatCollectionViewController(indexPath: IndexPath, user: User) {
        let chatCollectionViewController = ChatCollectionViewController(
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        present(
            NavigationStackManager.instance.presentCollectionViewController(
                collectionVC: chatCollectionViewController
            ), animated: true, completion: {
                chatCollectionViewController.user = user
            }
        )
    }

    private func openChatWithPartner(databaseRef: DatabaseReference, chatPartnerID: String, indexPath: IndexPath) {
        databaseRef.child(chatPartnerID).observeSingleEvent(of: .value) { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var user = User(dictionary: dictionary)
                user.id = chatPartnerID
                self.openChatCollectionViewController(indexPath: indexPath, user: user)
            }
        }
    }

    // MARK: Objc Methods
    @objc private func usersButtonDidTapped() {
        openUsersTableViewController()
    }

    @objc private func handleReloadTable() {
        sortChatsbByTimeInterval()
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
}
