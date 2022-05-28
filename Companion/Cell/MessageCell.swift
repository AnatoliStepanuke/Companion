import UIKit

final class MessageCell: UICollectionViewCell {
    // MARK: - Constants
    // MARK: Public
    let textView = UITextView()

    // MARK: - Override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextViewCell()
    }

    // MARK: - Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setups
    private func setupTextViewCell() {
        addSubview(textView)
        textView.text = "SAMPLE TEXT"
        textView.textAlignment = .right
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(
                top: 9,
                left: 12,
                bottom: 9,
                right: 12
            )
        )
    }
}
