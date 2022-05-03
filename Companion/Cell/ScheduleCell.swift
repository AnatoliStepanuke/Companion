import UIKit

final class ScheduleCell: UITableViewCell {
    // MARK: - Constants
    private let nameObjectLabel = UILabel()
    private let typeObjectLabel = UILabel()
    private let subjectStartTimeLabel = UILabel()
    private let subjectEndTimeLabel = UILabel()
    private let audienceNumberLabel = UILabel()
    private let teacherNameLabel = UILabel()

    // MARK: - Override methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
        setupNameObjectLabel()
        setupTypeObjectLabel()
        setupSubjectStartTimeLabel()
        setupSubjectEndTimeLabel()
        setupAudienceNumberLabel()
        setupTeacherNameLabel()
    }

    // MARK: - Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupView() {
        addSubview(nameObjectLabel)
        addSubview(typeObjectLabel)
        addSubview(subjectStartTimeLabel)
        addSubview(subjectEndTimeLabel)
        addSubview(audienceNumberLabel)
        addSubview(teacherNameLabel)
    }

    private func setupNameObjectLabel() {
        nameObjectLabel.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(top: -64, left: 20, bottom: 0, right: 120))
        nameObjectLabel.font = UIFont.boldSystemFont(ofSize: 21)
    }

    private func setupTypeObjectLabel() {
        typeObjectLabel.anchor(
            top: nameObjectLabel.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(top: -140, left: 20, bottom: 0, right: 20))
        typeObjectLabel.font = UIFont.systemFont(ofSize: 14)
    }

    private func setupSubjectStartTimeLabel() {
        subjectStartTimeLabel.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: nameObjectLabel.trailingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(top: -68, left: 10, bottom: 0, right: 20))
        subjectStartTimeLabel.font = UIFont.systemFont(ofSize: 14)
    }

    private func setupSubjectEndTimeLabel() {
        subjectEndTimeLabel.anchor(
            top: subjectStartTimeLabel.bottomAnchor,
            leading: nameObjectLabel.trailingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(top: -148, left: 10, bottom: 0, right: 20))
        subjectEndTimeLabel.font = UIFont.systemFont(ofSize: 14)
    }

    private func setupAudienceNumberLabel() {
        audienceNumberLabel.anchor(
            top: subjectEndTimeLabel.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(top: -36, left: 275, bottom: 0, right: 20))
        audienceNumberLabel.font = UIFont.systemFont(ofSize: 14)
    }

    private func setupTeacherNameLabel() {
        teacherNameLabel.anchor(
            top: typeObjectLabel.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(top: -36, left: 20, bottom: 0, right: 20))
        teacherNameLabel.font = UIFont.systemFont(ofSize: 14)
    }

    // MARK: - API
    func configure(using schedule: Schedule) {
        nameObjectLabel.text = schedule.nameSubject
        typeObjectLabel.text = schedule.typeSubject
        subjectStartTimeLabel.text = "\(schedule.subjectStartTime)"
        subjectEndTimeLabel.text = "\(schedule.subjectEndTime)"
        audienceNumberLabel.text = "\(schedule.audienceNumber)"
        teacherNameLabel.text = schedule.teacherName
    }
}
