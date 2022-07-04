import UIKit

final class CustomPlainUIButton: UIButton {
    // MARK: - Init
    init(systemName: String?, title: String?) {
        super.init(frame: .zero)
        setupConguration()
        setupSystemNameImage(systemName: systemName)
        setupForegroundColor()
        setupTitle(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupConguration() {
        configuration = .plain()
    }

    private func setupSystemNameImage(systemName: String?) {
        if let systemName = systemName {
            configuration?.image = UIImage(systemName: systemName)
        }
    }

    private func setupForegroundColor() {
        configuration?.baseForegroundColor = AppColor.blackColor
    }

    private func setupTitle(title: String?) {
        configuration?.title = title
        configuration?.titleAlignment = .trailing
    }
}
