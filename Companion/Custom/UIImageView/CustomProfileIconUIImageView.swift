import UIKit

final class CustomProfileIconUIImageView: UIImageView {
    // MARK: - Constants
    // MARK: - Private
    private let imageConfig = UIImage.SymbolConfiguration(pointSize: 5, weight: .ultraLight, scale: .medium)

    // MARK: - Init
    init(systemName: String) {
        super.init(frame: .zero)
        setupConstraints()
        setupImage(systemName: systemName)
        setupRound()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 35).isActive = true
        heightAnchor.constraint(equalToConstant: 35).isActive = true
    }

    private func setupImage(systemName: String) {
        image = UIImage(systemName: systemName, withConfiguration: imageConfig)
        tintColor = AppColor.blackColor
        contentMode = .scaleAspectFill
        isUserInteractionEnabled = true
    }

    private func setupRound() {
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
