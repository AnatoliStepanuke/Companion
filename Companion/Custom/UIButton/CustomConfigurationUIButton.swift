import UIKit

final class CustomConfigurationUIButton: UIButton {
    // MARK: - Init
    init(
        config: UIButton.Configuration,
        imageName: String?,
        imagePadding: CGFloat?,
        title: String?,
        subtitle: String?,
        textColor: UIColor?,
        buttonColor: UIColor?,
        buttonHeight: CGFloat?
    ) {
        super.init(frame: .zero)
        setupConguration(config: config)
        setupImage(imageName: imageName, imagePadding: imagePadding)
        setupText(
            title: title,
            subtitle: subtitle,
            textColor: textColor,
            buttonColor: buttonColor
        )
        setupHeight(height: buttonHeight)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupConguration(config: UIButton.Configuration) {
        configuration = config
    }

    private func setupImage(imageName: String?, imagePadding: CGFloat?) {
        if let imageName = imageName {
            if let imagePadding = imagePadding {
                configuration?.image = UIImage(systemName: imageName)
                configuration?.imagePadding = imagePadding
            } else {
                configuration?.image = UIImage(systemName: imageName)
            }
        }
    }

    private func setupText(title: String?, subtitle: String?, textColor: UIColor?, buttonColor: UIColor?) {
        configuration?.title = title
        configuration?.subtitle = subtitle
        configuration?.baseForegroundColor = textColor
        configuration?.baseBackgroundColor = buttonColor
    }

    private func setupHeight(height: CGFloat?) {
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
