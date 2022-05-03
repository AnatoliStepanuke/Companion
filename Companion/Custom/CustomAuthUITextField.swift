import UIKit

final class CustomTransparentUITextField: UITextField {
    // MARK: - Init
    init(placeholderText: String) {
        super.init(frame: .zero)
        setupHeightTextField()
        setupPlaceholderTextField(placeholderText: placeholderText)
        setupKeyboardType()
        setupBackgroundColor()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupHeightTextField() {
        heightAnchor.constraint(equalToConstant: 36).isActive = true
    }

    private func setupPlaceholderTextField(placeholderText: String) {
        placeholder = placeholderText
    }

    private func setupKeyboardType() {
        keyboardType = UIKeyboardType.default
        returnKeyType = UIReturnKeyType.done
        autocorrectionType = .no
    }

    private func setupBackgroundColor() {
        backgroundColor = AppColor.backgrounColor
    }
}
