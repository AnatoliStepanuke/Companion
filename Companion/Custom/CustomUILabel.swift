import UIKit

final class CustomUILabel: UILabel {
    // MARK: - Init
    init(text: String) {
        super.init(frame: .zero)
        setupText(labelText: text)
        setupFont()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupText(labelText: String) {
        text = labelText
        textAlignment = .center
    }

    private func setupFont() {
        font = .systemFont(ofSize: 17, weight: .medium)
    }
}
