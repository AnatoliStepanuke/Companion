import UIKit

final class CustomRoundedUIButton: UIButton {
    // MARK: - Init
    init(
        title: String?,
        buttonColor: UIColor?,
        fontColor: UIColor?,
        roundingRadius: CGFloat,
        buttonHeight: CGFloat?
    ) {
        super.init(frame: .zero)
        setupRoundedButton(roundingRadius: roundingRadius)
        setupTitleButton(title: title)
        setupColorsButton(buttonColor: buttonColor, fontColor: fontColor)
        setupHeight(height: buttonHeight)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupRoundedButton(roundingRadius: CGFloat) {
        layer.cornerRadius = roundingRadius
    }

    private func setupTitleButton(title: String?) {
        if let title = title {
            setTitle(title, for: .normal)
        }
    }

    private func setupColorsButton(buttonColor: UIColor?, fontColor: UIColor?) {
        if let buttonColor = buttonColor {
            if let fontColor = fontColor {
                setTitleColor(fontColor, for: .normal)
                backgroundColor = buttonColor
            } else {
                backgroundColor = buttonColor
            }
        }
    }

    private func setupHeight(height: CGFloat?) {
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
