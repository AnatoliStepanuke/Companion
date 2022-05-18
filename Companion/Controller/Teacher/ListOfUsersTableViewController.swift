import UIKit
import Firebase

final class ListOfUsersTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Constants
    // MARK: Private
    private let databaseReferenceToTeachers = FirebaseManager.instance.databaseReferenceToTeachers
    private let databaseReferenceToStudents = FirebaseManager.instance.databaseReferenceToStudents
    private let profileImageView = CustomProfileIconUIImageView(systemName: "person")
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let typesOfUsersSegmentedControl = UISegmentedControl()
    private let dismissButton = CustomPlainUIButton(systemName: "chevron.backward")
    private let navigationStackView = UIStackView()
    private let mainStackView = UIStackView()
    private let pageTitle = UILabel()

    // MARK: - Properties
    // MARK: Private
    private var users: [User] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationStackView()
        setupDismissButton()
        setupPageTitle()
        setupProfileImageView()
        setupMainStackView()
        setupTypesOfUsersSegmentedControl()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        showAllUsers()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = AppColor.shadowColor
        view.addSubview(navigationStackView)
        view.addSubview(mainStackView)
    }

    // MARK: NavigationStackView
    private func setupNavigationStackView() {
        navigationStackView.axis = .horizontal
        navigationStackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            bottom: mainStackView.topAnchor,
            padding: .init(top: 4, left: 24, bottom: 4, right: 24)
        )
        navigationStackView.heightAnchor.constraint(
            equalTo: mainStackView.heightAnchor,
            multiplier: 0.1
        ).isActive = true
        navigationStackView.addArrangedSubview(dismissButton)
        navigationStackView.addArrangedSubview(pageTitle)
        navigationStackView.addArrangedSubview(profileImageView)
        navigationStackView.alignment = .center
        navigationStackView.distribution = .equalCentering
    }

    private func setupDismissButton() {
        dismissButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
    }

    private func setupPageTitle() {
        pageTitle.text = "Contacts"
        pageTitle.textAlignment = .center
        pageTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }

    private func setupProfileImageView() {
        loadProfileImageView()
        profileImageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(profileImageViewDidTapped)
            )
        )
    }

    // MARK: MainStackView
    private func setupMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.anchor(
            top: navigationStackView.bottomAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            padding: .init(top: 4, left: 12, bottom: 8, right: 12)
        )
        mainStackView.addArrangedSubview(typesOfUsersSegmentedControl)
        mainStackView.addArrangedSubview(tableView)
    }

    private func setupTypesOfUsersSegmentedControl() {
        typesOfUsersSegmentedControl.addItems(items: [
            "Students",
            "Teachers"
        ])
        typesOfUsersSegmentedControl.selectedSegmentIndex = 0
        typesOfUsersSegmentedControl.addTarget(
            self,
            action: #selector(valueChangedTypesOfUsersSegmentedControl),
            for: .valueChanged
        )
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = AppColor.shadowColor
        tableView.rowHeight = 80
        tableView.register(
            UserCell.self,
            forCellReuseIdentifier: User.Constants.userCell
        )
    }

    // MARK: - Helpers
    private func loadProfileImageView() {
        if let userID = Auth.auth().currentUser?.uid {
            databaseReferenceToTeachers.child(userID).observeSingleEvent(of: .value) { snapshot in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User(dictionary: dictionary)
                    if let userIconURL = user.profileImageURL {
                        self.profileImageView.loadImageUsingCache(userIconURL)
                    }
                }
            }
        }
    }

    private func openTeacherProfileViewController() {
        let teacherProfileViewController = TeacherProfileViewController()
        present(teacherProfileViewController, animated: true)
    }

    private func openChatCollectionViewController(indexPath: IndexPath) {
        let pvc = self.presentingViewController
        let chatCollectionViewController = ChatCollectionViewController(
            collectionViewLayout: UICollectionViewFlowLayout()
        )

        dismiss(animated: true, completion: {
            pvc?.present(
                NavigationStackManager.instance.presentCollectionViewController(
                    collectionVC: chatCollectionViewController
                ), animated: true, completion: {
                    let user = self.users[indexPath.row]
                    chatCollectionViewController.user = user
                }
            )
        })
    }

    // Firebase
    private func fetchTeacherUsers() {
        users.removeAll()
        databaseReferenceToTeachers.observe(.childAdded, with: { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var user = User(dictionary: dictionary)
                user.id = snapshot.key
                self.users.append(user)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
    }

    private func fetchStudentUsers() {
        users.removeAll()
        databaseReferenceToStudents.observe(.childAdded, with: { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var user = User(dictionary: dictionary)
                user.id = snapshot.key
                self.users.append(user)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
    }

    private func showAllUsers() {
        switch typesOfUsersSegmentedControl.selectedSegmentIndex {
        case 0: fetchStudentUsers()
        case 1: fetchTeacherUsers()
        default: print("Contacts: Something going bad wrong")
        }
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: User.Constants.userCell,
            for: indexPath
        ) as? UserCell else {
            fatalError("DequeueReusableCell failed while casting.")
        }
        cell.selectionStyle = .none
        cell.backgroundColor = AppColor.shadowColor
        cell.configure(using: users[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openChatCollectionViewController(indexPath: indexPath)
    }

    // MARK: - Actions
    // MARK: Objc Methods
    @objc func dismissButtonDidTapped() { dismiss(animated: true, completion: nil) }

    @objc func profileImageViewDidTapped() { openTeacherProfileViewController() }

    @objc private func valueChangedTypesOfUsersSegmentedControl() { showAllUsers() }
}
