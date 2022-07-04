import UIKit

final class CustomUITextField: UITextField {
    // MARK: - Init
    init(placeholderText: String) {
        super.init(frame: .zero)
        setupRoundedTextField()
        setupCenterPlaceholderAligment(placeholderText: placeholderText)
        setupKeyboardType()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Setups
    private func setupRoundedTextField() {
        layer.cornerRadius = 4
        clipsToBounds = true
    }

    private func setupCenterPlaceholderAligment(placeholderText: String) {
        textAlignment = .center
        placeholder = placeholderText
    }

    private func setupKeyboardType() {
        keyboardType = UIKeyboardType.default
        returnKeyType = UIReturnKeyType.done
    }
}
