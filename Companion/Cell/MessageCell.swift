import UIKit

final class MessageCell: UITableViewCell {
    // MARK: - Constants
    private let containerStackView = UIStackView()
    private let profileImageStackView = UIStackView()
    private let initialsStackView = UIStackView()
    private let userProfileImageView = CustomProfileUIImageView(systemName: "person.fill")
    private let companionNameLabel = UILabel()
    private let textMessageLabel = UILabel()

    // MARK: - Override methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainerView()
        setupProfileImageStackView()
        setupInitialsStackView()
        setupUserNameLabel()
        setupUserEmailLabel()
    }

    // MARK: - Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupContainerView() {
        self.addSubview(containerStackView)
        containerStackView.axis = .horizontal
        containerStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(
                top: 12,
                left: 0,
                bottom: 12,
                right: 0
            )
        )
        containerStackView.backgroundColor = AppColor.shadowColor
        containerStackView.addArrangedSubview(profileImageStackView)
        containerStackView.addArrangedSubview(initialsStackView)
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
            equalTo: initialsStackView.widthAnchor, multiplier: 0.25
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
        initialsStackView.distribution = .fillProportionally
    }

    private func setupUserNameLabel() {
        companionNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        companionNameLabel.textAlignment = .left
        companionNameLabel.numberOfLines = 0
    }

    private func setupUserEmailLabel() {
        textMessageLabel.font = UIFont.systemFont(ofSize: 15)
        textMessageLabel.textAlignment = .left
        textMessageLabel.textColor = .gray
    }

    // MARK: - API
    func configure(using message: Message) {
        companionNameLabel.text = message.toUserID
        textMessageLabel.text = message.text
    }
}
