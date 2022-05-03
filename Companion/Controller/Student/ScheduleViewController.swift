import UIKit

final class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    // MARK: - Private
    private var mondaySchedule: [Schedule] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private var tuesdaySchedule: [Schedule] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private var wednesdaySchedule: [Schedule] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private var thursdaySchedule: [Schedule] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private var fridaySchedule: [Schedule] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private var saturdaySchedule: [Schedule] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private var rowsToDisplay: [Schedule] = []

    // MARK: - Constants
    // MARK: - Private
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let cell = UITableViewCell()
    private let date = Date()
    lazy private var segmentedControl: UISegmentedControl = {
        let itemedSegmentedControl = UISegmentedControl(items: [
            "Mon.",
            "Tues.",
            "Wed.",
            "Thurs.",
            "Fri.",
            "Sat."
        ])
        itemedSegmentedControl.addTarget(
            self,
            action: #selector(handleSegmentControlChange),
            for: .valueChanged
        )
        return itemedSegmentedControl
    }()
    lazy private var stackView = UIStackView(arrangedSubviews: [
        tableView,
        segmentedControl
    ])

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupNavigationController()
        setupStuckView()
        mondaySchedule = fetchMondaySchedule()
        tuesdaySchedule = fetchTuesdaySchedule()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = AppColor.backgrounColor
        view.addSubview(stackView)
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = AppColor.backgrounColor
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        tableView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: segmentedControl.topAnchor,
            padding: .init(top: 0, left: 12, bottom: 12, right: 12))
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: Schedule.Constants.scheduleCell)
    }

    private func setupNavigationController() {
        title = "Schedule"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupStuckView() {
        stackView.axis = .vertical
        stackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            padding: .init(
                top: 0,
                left: 0,
                bottom: 12,
                right: 0
            ),
            size: .zero
        )
    }

    // MARK: - Actions
    // MARK: Objc Methods
    @objc func handleSegmentControlChange(_ segmentControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            rowsToDisplay = mondaySchedule
        case 1:
            rowsToDisplay = tuesdaySchedule
        case 2:
            rowsToDisplay = wednesdaySchedule
        case 3:
            rowsToDisplay = thursdaySchedule
        case 4:
            rowsToDisplay = fridaySchedule
        case 5:
            rowsToDisplay = saturdaySchedule
        default:
            print("can't display schedule.")
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsToDisplay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Schedule.Constants.scheduleCell,
            for: indexPath
        ) as? ScheduleCell else {
            fatalError("DequeueReusableCell failed while casting.")
        }
        cell.configure(using: rowsToDisplay[indexPath.row])

        return cell
    }
}

extension ScheduleViewController {
    func fetchMondaySchedule() -> [Schedule] {
        let subject1 = Schedule.init(
            nameSubject: "Math",
            typeSubject: "Practice",
            subjectStartTime: date,
            subjectEndTime: date,
            audienceNumber: 402,
            teacherName: "Koleda Maria")
        let subject2 = Schedule.init(
            nameSubject: "OOP",
            typeSubject: "Lecture",
            subjectStartTime: date,
            subjectEndTime: date,
            audienceNumber: 404,
            teacherName: "Voronov Sergei")
        let subject3 = Schedule.init(
            nameSubject: "Physical Culture",
            typeSubject: "",
            subjectStartTime: date,
            subjectEndTime: date,
            audienceNumber: 102,
            teacherName: "Francievna Elena")
        let subject4 = Schedule.init(
            nameSubject: "Physics",
            typeSubject: "Laboratory",
            subjectStartTime: date,
            subjectEndTime: date,
            audienceNumber: 407,
            teacherName: "Chugunov Sergei")
        return [subject1, subject2, subject3, subject4]
    }

    func fetchTuesdaySchedule() -> [Schedule] {
        let subject1 = Schedule.init(
            nameSubject: "Modern Systems of Programming",
            typeSubject: "Lecture",
            subjectStartTime: date,
            subjectEndTime: date,
            audienceNumber: 210,
            teacherName: "Voicehovich Leonid")
        let subject2 = Schedule.init(
            nameSubject: "Modern Systems of Programming",
            typeSubject: "Lecture",
            subjectStartTime: date,
            subjectEndTime: date,
            audienceNumber: 210,
            teacherName: "Voicehovich Leonid")
        let subject3 = Schedule.init(
            nameSubject: "Intellectual Systems",
            typeSubject: "Lecture",
            subjectStartTime: date,
            subjectEndTime: date,
            audienceNumber: 404,
            teacherName: "Shutz V.N.")
        let subject4 = Schedule.init(
            nameSubject: "Modern Systems of Programming",
            typeSubject: "Laboratory",
            subjectStartTime: date,
            subjectEndTime: date,
            audienceNumber: 406,
            teacherName: "Voicehovich Leonid")
        return [subject1, subject2, subject3, subject4]
    }
}
