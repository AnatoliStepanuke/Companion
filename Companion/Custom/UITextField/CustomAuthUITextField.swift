import UIKit

final class CustomAuthUITextField: UITextField {
    // MARK: - Init
    init(
        placeholderText: String,
        autocapitalizationType: UITextAutocapitalizationType,
        keyboardType: UIKeyboardType
    ) {
        super.init(frame: .zero)
        setupHeightTextField()
        setupPlaceholderTextField(placeholderText: placeholderText)
        setupKeyboardType(
            autocapitalizationType: autocapitalizationType,
            keyboardType: keyboardType
        )
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

    private func setupKeyboardType(
        autocapitalizationType: UITextAutocapitalizationType,
        keyboardType: UIKeyboardType
    ) {
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        autocorrectionType = .no
        returnKeyType = UIReturnKeyType.continue
    }

    private func setupBackgroundColor() {
        backgroundColor = AppColor.shadowColor
    }
}
