import UIKit

final class CustomRoundedUIButton: UIButton {
    // MARK: - Init
    init(title: String, fontColor: UIColor) {
        super.init(frame: .zero)
        setupHeightButton()
        setupRoundedButton()
        setupTitleButton(title: title)
        setupColorsButton(fontColor: fontColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupHeightButton() {
        heightAnchor.constraint(equalToConstant: 36).isActive = true
    }

    private func setupRoundedButton() {
        layer.cornerRadius = 16
    }

    private func setupTitleButton(title: String) {
        setTitle(title, for: .normal)
    }

    private func setupColorsButton(fontColor: UIColor) {
        setTitleColor(fontColor, for: .normal)
        backgroundColor = .white
    }
}
