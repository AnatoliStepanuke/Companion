import UIKit

final class UsersTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Constants
    // MARK: Private
    private let databaseReferenceToTeachers = FirebaseManager.instance.databaseReferenceToTeachers
    private let navigationStackView = UIStackView()
    private let mainStackView = UIStackView()
    private let dismissButton = UIButton(type: .system)
    private let fetchButton = UIButton(type: .system)
    private let pageTitle = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)

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
        setupFetchButton()
        setupMainStackView()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchTeacherUsers()
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
            padding: .init(top: 12, left: 0, bottom: 8, right: 0)
        )
       navigationStackView.heightAnchor.constraint(
            equalTo: mainStackView.heightAnchor,
            multiplier: 0.1
        ).isActive = true
        navigationStackView.addArrangedSubview(dismissButton)
        navigationStackView.addArrangedSubview(pageTitle)
        navigationStackView.addArrangedSubview(fetchButton)
        navigationStackView.alignment = .center
        navigationStackView.distribution = .fillEqually
    }

    private func setupDismissButton() {
        dismissButton.setTitle("Back", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
    }

    private func setupPageTitle() {
        pageTitle.text = "Users"
        pageTitle.textAlignment = .center
        pageTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }

    private func setupFetchButton() {
        fetchButton.setTitle("Fetch", for: .normal)
        fetchButton.addTarget(self, action: #selector(fetchButtonDidTapped), for: .touchUpInside)
    }

    // MARK: MainStackView
    private func setupMainStackView() {
        mainStackView.anchor(
            top: navigationStackView.bottomAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            padding: .init(top: 8, left: 0, bottom: 8, right: 0)
        )
        mainStackView.addArrangedSubview(tableView)
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
    private func fetchTeacherUsers() {
        databaseReferenceToTeachers.observe(.childAdded, with: { snapshot in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                print(dictionary)
                let user = User(dictionary: dictionary)
                self.users.append(user)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
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
        cell.backgroundColor = AppColor.shadowColor
        cell.configure(using: users[indexPath.row])

        return cell
    }

    // MARK: - Actions
    // MARK: Objc Methods
    @objc func dismissButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func fetchButtonDidTapped() {
        tableView.reloadData()
    }
}
