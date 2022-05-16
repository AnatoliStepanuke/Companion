import UIKit

final class CustomPlainUIButton: UIButton {
    // MARK: - Init
    init(systemName: String) {
        super.init(frame: .zero)
        setupConguration()
        setupSystemNameImage(systemName: systemName)
        setupForegroundColor()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupConguration() {
        configuration = .plain()
    }

    private func setupSystemNameImage(systemName: String) {
        configuration?.image = UIImage(systemName: systemName)
    }

    private func setupForegroundColor() {
        configuration?.baseForegroundColor = AppColor.blackColor
    }
}
