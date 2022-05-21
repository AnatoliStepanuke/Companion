import UIKit

final class ScheduleCell: UITableViewCell {
    // MARK: - Constants
    // UIStackView()
    private let containerStackView = UIStackView()
    private let topVerticalStackView = UIStackView()
    private let bottomVerticalStackView = UIStackView()
    private let nameAndTypeSubjectStackView = UIStackView()
    private let buildingAndAudienceNumberStackView = UIStackView()
    private let startAndEndTimeSubjectStackView = UIStackView()
    private let teacherNameStackView = UIStackView()

    // UILabel()
    private let nameSubjectLabel = UILabel()
    private let typeSubjectLabel = UILabel()
    private let subjectStartTimeLabel = UILabel()
    private let separatorSubjectTimeLabel = UILabel()
    private let subjectEndTimeLabel = UILabel()
    private let teacherNameLabel = UILabel()
    private let audienceNumberLabel = UILabel()
    private let separatorBuildingAndAudienceLabel = UILabel()
    private let buildingNumberLabel = UILabel()

    // MARK: - Override methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainerView()
        setupTopVerticalStackView()
        setupBottomVerticalStackView()
        setupNameAndTypeSubjectStackView()
        setupStartAndEndTimeSubjectStackView()
        setupTeacherNameStackView()
        setupBuildingAndAudienceNumberStackView()
        setupNameSubjectLabel()
        setupTypeSubjectLabel()
        setupBuildingNumberLabel()
        setupSeparatorBuildingAndAudienceLabel()
        setupAudienceNumberLabel()
        setupTeacherNameLabel()
        setupSubjectStartTimeLabel()
        setupSeparatorSubjectTimeLabel()
        setupSubjectEndTimeLabel()
    }

    // MARK: - Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupContainerView() {
        self.addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(
                top: 6,
                left: 2,
                bottom: 6,
                right: 2
            )
        )
        containerStackView.backgroundColor = AppColor.whiteColor
        containerStackView.layer.cornerRadius = 12
        containerStackView.addArrangedSubview(topVerticalStackView)
        containerStackView.addArrangedSubview(bottomVerticalStackView)
    }

    // MARK: - SetupTopVerticalStackView
    private func setupTopVerticalStackView() {
        topVerticalStackView.axis = .horizontal
        topVerticalStackView.anchor(
            top: containerStackView.topAnchor,
            leading: containerStackView.leadingAnchor,
            trailing: containerStackView.trailingAnchor,
            bottom: bottomVerticalStackView.topAnchor,
            padding: .init(top: 6, left: 12, bottom: 0, right: 12)
        )
        topVerticalStackView.addArrangedSubview(nameAndTypeSubjectStackView)
        topVerticalStackView.addArrangedSubview(buildingAndAudienceNumberStackView)
        topVerticalStackView.alignment = .lastBaseline
    }

    // setupNameAndTypeSubjectStackView
    private func setupNameAndTypeSubjectStackView() {
        nameAndTypeSubjectStackView.axis = .vertical
        nameAndTypeSubjectStackView.addArrangedSubview(nameSubjectLabel)
        nameAndTypeSubjectStackView.addArrangedSubview(typeSubjectLabel)
        nameAndTypeSubjectStackView.distribution = .fillProportionally
    }

    private func setupNameSubjectLabel() {
        nameSubjectLabel.font = UIFont.boldSystemFont(ofSize: 17)
        nameSubjectLabel.textAlignment = .left
        nameSubjectLabel.numberOfLines = 0
    }

    private func setupTypeSubjectLabel() {
        typeSubjectLabel.font = UIFont.systemFont(ofSize: 15)
        typeSubjectLabel.textAlignment = .left
    }

    // setupBuildingAndAudienceNumberStackView
    private func setupBuildingAndAudienceNumberStackView() {
        buildingAndAudienceNumberStackView.axis = .horizontal
        buildingAndAudienceNumberStackView.widthAnchor.constraint(
            equalTo: topVerticalStackView.widthAnchor,
            multiplier: 0.15
        ).isActive = true
        buildingAndAudienceNumberStackView.addArrangedSubview(buildingNumberLabel)
        buildingAndAudienceNumberStackView.addArrangedSubview(separatorBuildingAndAudienceLabel)
        buildingAndAudienceNumberStackView.addArrangedSubview(audienceNumberLabel)
        buildingAndAudienceNumberStackView.spacing = 2
        buildingAndAudienceNumberStackView.distribution = .fillProportionally
    }

    private func setupBuildingNumberLabel() {
        buildingNumberLabel.font = UIFont.systemFont(ofSize: 15)
        buildingNumberLabel.textAlignment = .left
    }

    private func setupSeparatorBuildingAndAudienceLabel() {
        separatorBuildingAndAudienceLabel.text = "\u{002F}"
        separatorBuildingAndAudienceLabel.textAlignment = .left
    }

    private func setupAudienceNumberLabel() {
        audienceNumberLabel.font = UIFont.systemFont(ofSize: 15)
        audienceNumberLabel.textAlignment = .left
    }

    // MARK: - SetupBottomVerticalStackView
    private func setupBottomVerticalStackView() {
        bottomVerticalStackView.axis = .horizontal
        bottomVerticalStackView.anchor(
            top: topVerticalStackView.bottomAnchor,
            leading: containerStackView.leadingAnchor,
            trailing: containerStackView.trailingAnchor,
            bottom: containerStackView.bottomAnchor,
            padding: .init(top: 0, left: 12, bottom: 6, right: 6)
        )
        bottomVerticalStackView.heightAnchor.constraint(
            equalTo: containerStackView.heightAnchor,
            multiplier: 0.45
        ).isActive = true
        bottomVerticalStackView.addArrangedSubview(teacherNameStackView)
        bottomVerticalStackView.addArrangedSubview(startAndEndTimeSubjectStackView)
        bottomVerticalStackView.alignment = .center
    }

    // setupTeacherNameStackView
    private func setupTeacherNameStackView() {
        teacherNameStackView.widthAnchor.constraint(
            equalTo: bottomVerticalStackView.widthAnchor,
            multiplier: 0.5
        ).isActive = true
        teacherNameStackView.addArrangedSubview(teacherNameLabel)
    }

    private func setupTeacherNameLabel() {
        teacherNameLabel.font = UIFont.systemFont(ofSize: 13)
        teacherNameLabel.textAlignment = .left
        teacherNameLabel.numberOfLines = 0
    }

    // setupStartAndEndTimeSubjectStackView
    private func setupStartAndEndTimeSubjectStackView() {
        startAndEndTimeSubjectStackView.axis = .vertical
        startAndEndTimeSubjectStackView.widthAnchor.constraint(
            equalTo: bottomVerticalStackView.widthAnchor,
            multiplier: 0.2
        ).isActive = true
        startAndEndTimeSubjectStackView.addArrangedSubview(subjectStartTimeLabel)
        startAndEndTimeSubjectStackView.addArrangedSubview(separatorSubjectTimeLabel)
        startAndEndTimeSubjectStackView.addArrangedSubview(subjectEndTimeLabel)
    }

    private func setupSubjectStartTimeLabel() {
        subjectStartTimeLabel.font = UIFont.systemFont(ofSize: 13)
        subjectStartTimeLabel.textAlignment = .right
    }

    private func setupSeparatorSubjectTimeLabel() {
        separatorSubjectTimeLabel.text = "\u{2E3B}"
        separatorSubjectTimeLabel.textAlignment = .right
    }

    private func setupSubjectEndTimeLabel() {
        subjectEndTimeLabel.font = UIFont.systemFont(ofSize: 13)
        subjectEndTimeLabel.textAlignment = .right
    }

    // MARK: - API
    func configure(using schedule: Schedule) {
        nameSubjectLabel.text = schedule.nameSubject
        typeSubjectLabel.text = schedule.typeSubject
        subjectStartTimeLabel.text = "\(schedule.subjectStartTimeDescription)"
        subjectEndTimeLabel.text = "\(schedule.subjectEndTimeDescription)"
        buildingNumberLabel.text = "\(schedule.buildingNumber)"
        audienceNumberLabel.text = "\(schedule.audienceNumber)"
        teacherNameLabel.text = schedule.teacherName
    }
}
