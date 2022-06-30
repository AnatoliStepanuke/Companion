import UIKit

final class MessageCell: UICollectionViewCell {
    // MARK: - Constants
    // MARK: Private
    private let messageBubbleView = UIView()

    // MARK: Public
    let messageTextView = UITextView()

    // MARK: - Variables
    // MARK: Public
    var messageBubbleWidth: NSLayoutConstraint?

    // MARK: - Override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMessageBubbleView()
        setupMessageTextView()
    }

    // MARK: - Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setups
    private func setupMessageBubbleView() {
        addSubview(messageBubbleView)
        messageBubbleView.anchor(
            top: topAnchor,
            leading: nil,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(
                top: 9,
                left: 0,
                bottom: 0,
                right: 12
            )
        )
        messageBubbleWidth = messageBubbleView.widthAnchor.constraint(equalToConstant: 0)
        messageBubbleWidth?.isActive = true
        messageBubbleView.backgroundColor = .systemBlue
        messageBubbleView.layer.cornerRadius = 16
        messageBubbleView.layer.masksToBounds = true
    }

    private func setupMessageTextView() {
        addSubview(messageTextView)
        messageTextView.anchor(
            top: messageBubbleView.topAnchor,
            leading: messageBubbleView.leadingAnchor,
            trailing: messageBubbleView.trailingAnchor,
            bottom: messageBubbleView.bottomAnchor,
            padding: .init(
                top: 1,
                left: 8,
                bottom: 1,
                right: 4
            )
        )
        messageTextView.isEditable = false
        messageTextView.backgroundColor = .clear
        messageTextView.font = UIFont.systemFont(ofSize: 16)
        messageTextView.textColor = .white
    }
}
