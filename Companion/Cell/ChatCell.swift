import UIKit

final class ChatCell: UITableViewCell {
    // MARK: - Constants
    private let userProfileImageView = CustomProfileUIImageView(systemName: "person.fill")

    // Firebase
    private let databaseReferenceToStudents = FirebaseManager.instance.databaseReferenceToStudents
    private let databaseReferenceToTeachers = FirebaseManager.instance.databaseReferenceToTeachers

    // UIStackView()
    private let containerStackView = UIStackView()
    private let profileImageStackView = UIStackView()
    private let initialsStackView = UIStackView()
    private let timeStackView = UIStackView()

    // UILabel
    private let companionNameLabel = UILabel()
    private let textMessageLabel = UILabel()
    private let timeLabel = UILabel()

    // MARK: - Override methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainerView()
        setupProfileImageStackView()
        setupInitialsStackView()
        setupСompanionNameLabel()
        setupTextMessageLabel()
        setupTimeStackView()
        setupTimeLabel()
    }

    // MARK: - Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupContainerView() {
        addSubview(containerStackView)
        containerStackView.axis = .horizontal
        containerStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(
                top: 9,
                left: 12,
                bottom: 9,
                right: 12
            )
        )
        containerStackView.backgroundColor = AppColor.shadowColor
        containerStackView.addArrangedSubview(profileImageStackView)
        containerStackView.addArrangedSubview(initialsStackView)
        containerStackView.addArrangedSubview(timeStackView)
    }

    // MARK: SetupProfileImageStackView
    private func setupProfileImageStackView() {
        profileImageStackView.anchor(
            top: containerStackView.topAnchor,
            leading: containerStackView.leadingAnchor,
            trailing: initialsStackView.leadingAnchor,
            bottom: containerStackView.bottomAnchor,
            padding: .init(top: 0, left: 12, bottom: 0, right: 12)
        )
        profileImageStackView.widthAnchor.constraint(
            equalTo: containerStackView.widthAnchor, multiplier: 0.20
        ).isActive = true
        profileImageStackView.addArrangedSubview(userProfileImageView)
    }

    // MARK: SetupInitialsStackView
    private func setupInitialsStackView() {
        initialsStackView.axis = .vertical
        initialsStackView.anchor(
            top: containerStackView.topAnchor,
            leading: profileImageStackView.trailingAnchor,
            trailing: containerStackView.trailingAnchor,
            bottom: containerStackView.bottomAnchor,
            padding: .init(top: 6, left: 12, bottom: 6, right: 12)
        )
        initialsStackView.addArrangedSubview(companionNameLabel)
        initialsStackView.addArrangedSubview(textMessageLabel)
        initialsStackView.distribution = .equalSpacing
    }

    private func setupСompanionNameLabel() {
        companionNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        companionNameLabel.textAlignment = .left
        companionNameLabel.numberOfLines = 0
    }

    private func setupTextMessageLabel() {
        textMessageLabel.font = UIFont.systemFont(ofSize: 15)
        textMessageLabel.textAlignment = .left
        textMessageLabel.numberOfLines = 0
    }

    // MARK: SetupTimeStackView
    private func setupTimeStackView() {
        timeStackView.widthAnchor.constraint(
            equalTo: containerStackView.widthAnchor, multiplier: 0.2
        ).isActive = true
        timeStackView.alignment = .leading
        timeStackView.addArrangedSubview(timeLabel)
    }

    private func setupTimeLabel() {
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textAlignment = .right
        timeLabel.textColor = .gray
    }

    // MARK: - Helpers
    private func fetchTeacherCompanionNameLabel(chatPartnerId: String) {
        FirebaseManager.instance.fetchUserPartnerNameLabel(
            dictionaryKey: "name",
            chatPartnerId: chatPartnerId,
            label: companionNameLabel,
            databaseRef: databaseReferenceToTeachers
        )
    }

    private func fetchStudentCompanionNameLabel(chatPartnerId: String) {
        FirebaseManager.instance.fetchUserPartnerNameLabel(
            dictionaryKey: "name",
            chatPartnerId: chatPartnerId,
            label: companionNameLabel,
            databaseRef: databaseReferenceToStudents
        )
    }

    private func fetchTeacherCompanionProfileImageView(chatPartnerId: String) {
        FirebaseManager.instance.fetchUserPartnerProfileImageView(
            imageView: userProfileImageView,
            chatPartnerId: chatPartnerId,
            databaseRef: databaseReferenceToTeachers
        )
    }

    private func fetchStudentCompanionProfileImageView(chatPartnerId: String) {
        FirebaseManager.instance.fetchUserPartnerProfileImageView(
            imageView: userProfileImageView,
            chatPartnerId: chatPartnerId,
            databaseRef: databaseReferenceToStudents
        )
    }

    // MARK: - API
    func configure(using chat: Chat) {
        if let chatPartnerId = chat.chatPartnerId() {
            fetchTeacherCompanionNameLabel(chatPartnerId: chatPartnerId)
            fetchStudentCompanionNameLabel(chatPartnerId: chatPartnerId)
            fetchTeacherCompanionProfileImageView(chatPartnerId: chatPartnerId)
            fetchStudentCompanionProfileImageView(chatPartnerId: chatPartnerId)
        }

        companionNameLabel.text = chat.toUserID
        textMessageLabel.text = chat.text
        timeLabel.text = chat.timeDescription
    }
}
