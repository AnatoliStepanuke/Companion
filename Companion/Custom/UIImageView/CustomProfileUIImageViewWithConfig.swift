import UIKit

final class CustomProfileUIImageViewWithConfig: UIImageView {
    // MARK: - Init
    init(systemName: String, height: CGFloat, width: CGFloat, pointSize: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale) {
        super.init(frame: .zero)
        setupConstraints(height: height, width: width)
        setupImage(systemName: systemName, pointSize: pointSize, weight: weight, scale: scale)
        setupRound()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups
    private func setupConstraints(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: height).isActive = true
        heightAnchor.constraint(equalToConstant: width).isActive = true
    }

    private func setupConfiguration(pointSize: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale) -> UIImage.Configuration {
        return UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale)
    }

    private func setupImage(systemName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale) {
        image = UIImage(systemName: systemName, withConfiguration: setupConfiguration(
            pointSize: pointSize,
            weight: weight,
            scale: scale
        ))
        tintColor = AppColor.blackColor
        contentMode = .scaleAspectFill
        isUserInteractionEnabled = true
    }

    private func setupRound() {
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
