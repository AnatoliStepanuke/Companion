import UIKit

final class UserCell: UITableViewCell {
    // MARK: - Constants
    private let containerStackView = UIStackView()
    private let initialsStackView = UIStackView()
    private let userNameLabel = UILabel()
    private let userEmailLabel = UILabel()

    // MARK: - Override methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainerView()
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
        containerStackView.axis = .vertical
        containerStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0
            )
        )
        containerStackView.backgroundColor = AppColor.whiteColor
        containerStackView.addArrangedSubview(initialsStackView)
    }

    private func setupInitialsStackView() {
        initialsStackView.axis = .vertical
        initialsStackView.anchor(
            top: containerStackView.topAnchor,
            leading: containerStackView.leadingAnchor,
            trailing: containerStackView.trailingAnchor,
            bottom: containerStackView.bottomAnchor,
            padding: .init(top: 6, left: 12, bottom: 6, right: 12)
        )
        initialsStackView.addArrangedSubview(userNameLabel)
        initialsStackView.addArrangedSubview(userEmailLabel)
        initialsStackView.distribution = .fillProportionally
    }

    private func setupUserNameLabel() {
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        userNameLabel.textAlignment = .left
        userNameLabel.numberOfLines = 0
    }

    private func setupUserEmailLabel() {
        userEmailLabel.font = UIFont.systemFont(ofSize: 15)
        userEmailLabel.textAlignment = .left
    }

    // MARK: - API
    func configure(using user: User) {
        userNameLabel.text = user.name
        userEmailLabel.text = user.email
    }
}
