import UIKit

final class CustomProfileUIImageView: UIImageView {
    // MARK: - Init
    init(systemName: String) {
        super.init(frame: .zero)
        setupImage(systemName: systemName)
        setupRound()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupImage(systemName: String) {
        image = UIImage(systemName: systemName)
        tintColor = AppColor.blackColor
        contentMode = .scaleAspectFill
        isUserInteractionEnabled = true
    }

    private func setupRound() {
        frame.size.width = 20
        frame.size.height = 20
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
