import UIKit

final class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Constants
    // MARK: - Private
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let scheduleStackView = UIStackView()

    // MARK: - Properties
    // MARK: - Private
    private var typesOfWeeksSegmentedControl = UISegmentedControl() {
        didSet {
            updateCurrentSchedule()
        }
    }
    private var daysOfWeekSegmentedControl = UISegmentedControl() {
        didSet {
            updateCurrentSchedule()
        }
    }
    private var scheduleFromUserDefaults: [Schedule] = []
    private var filteredSchedule: [Schedule] = []
    private var type: ScheduleWeekType?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupScheduleStuckView()
        setupTypesOfWeekSegmentedControl()
        setupDaysOfWeekSegmentedControl()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCurrentSchedule()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scheduleFromUserDefaults = UserManager.instance.getScheduleFromUserDefaults()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = AppColor.shadowColor
        view.addSubview(scheduleStackView)
    }

    private func setupNavigationController() {
        title = "Schedule"
        navigationController?.navigationBar.prefersLargeTitles = true
        let plusButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(plusButtonDidTapped))
        plusButton.tintColor = AppColor.blackColor
        navigationItem.setRightBarButton(plusButton, animated: true)
    }

    private func setupScheduleStuckView() {
        scheduleStackView.axis = .vertical
        scheduleStackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            padding: .init(top: 6, left: 8, bottom: 6, right: 8)
        )
        scheduleStackView.spacing = 6
        scheduleStackView.addArrangedSubview(typesOfWeeksSegmentedControl)
        scheduleStackView.addArrangedSubview(tableView)
        scheduleStackView.addArrangedSubview(daysOfWeekSegmentedControl)
    }

    private func setupTypesOfWeekSegmentedControl() {
        typesOfWeeksSegmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        typesOfWeeksSegmentedControl.addItems(items: [
            "UPPER WEEK",
            "BOTTOM WEEK"
        ])
        typesOfWeeksSegmentedControl.addTarget(
            self,
            action: #selector(valueChangedSegmentedControl),
            for: .valueChanged
        )
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.backgroundColor = AppColor.shadowColor
        tableView.rowHeight = 155
        tableView.separatorStyle = .none
        tableView.register(
            ScheduleCell.self,
            forCellReuseIdentifier: Schedule.Constants.scheduleCell
        )
    }

    private func setupDaysOfWeekSegmentedControl() {
        daysOfWeekSegmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        daysOfWeekSegmentedControl.addItems(items: [
            "Mon.",
            "Tues.",
            "Wed.",
            "Thurs.",
            "Fri.",
            "Sat."
        ])
        daysOfWeekSegmentedControl.addTarget(self, action: #selector(valueChangedSegmentedControl), for: .valueChanged)
    }

    // MARK: - Helpers
    private func openScreenForSaveSubjectViewController() {
        let screenForSaveScheduleViewController = ScreenForSaveSubjectViewController()
        present(
            NavigationStackManager.instance.modalPresentFullScreenViewController(
                viewController: screenForSaveScheduleViewController
            ), animated: true, completion: nil
        )
    }

    // MARK: - Actions
    private func updateCurrentSchedule() {
        let weekType = typesOfWeeksSegmentedControl.selectedSegmentIndex
        let day = daysOfWeekSegmentedControl.selectedSegmentIndex

        if weekType == 0 {
            switch day {
            case 0: type = .upper(.monday)
            case 1: type = .upper(.tuesday)
            case 2: type = .upper(.wednesday)
            case 3: type = .upper(.thursday)
            case 4: type = .upper(.friday)
            case 5: type = .upper(.saturday)
            default: print("choosed upper week type")
            }
        } else if weekType == 1 {
            switch day {
            case 0: type = .bottom(.monday)
            case 1: type = .bottom(.tuesday)
            case 2: type = .bottom(.wednesday)
            case 3: type = .bottom(.thursday)
            case 4: type = .bottom(.friday)
            case 5: type = .bottom(.saturday)
            default: print("choosed bottom week type")
            }
        }

        filteredSchedule = scheduleFromUserDefaults.filter { $0.scheduleDateType == type }
        tableView.reloadData()
    }

    // MARK: Objc Methods
    @objc private func plusButtonDidTapped() {
        openScreenForSaveSubjectViewController()
    }

    @objc private func valueChangedSegmentedControl() { updateCurrentSchedule() }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSchedule.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Schedule.Constants.scheduleCell,
            for: indexPath
        ) as? ScheduleCell else {
            fatalError("DequeueReusableCell failed while casting.")
        }
        cell.backgroundColor = AppColor.shadowColor
        cell.configure(using: filteredSchedule[indexPath.row])

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete",
            handler: { (_:UIContextualAction, _:UIView, _:(Bool) -> Void) in
                self.filteredSchedule.remove(at: indexPath.row)
                self.scheduleFromUserDefaults.remove(at: indexPath.row)
                UserManager.instance.updateSchedulesFromUserDefaults(updatedSchedules: self.scheduleFromUserDefaults)
                tableView.reloadData()
            }
        )

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
