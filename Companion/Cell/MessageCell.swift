import UIKit

final class MessageCell: UICollectionViewCell {
    // MARK: - Constants
    // MARK: Public
    let messageBubbleView = UIView()
    let messageTextView = UITextView()

    // MARK: - Variables
    // MARK: Public
    var messageBubbleWidth: NSLayoutConstraint?
    var messageBubbleLeftAnchor: NSLayoutConstraint?
    var messageBubbleRightAnchor: NSLayoutConstraint?

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
        messageBubbleRightAnchor = messageBubbleView.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -12
        )
        messageBubbleLeftAnchor = messageBubbleView.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: 12
        )
        messageBubbleView.anchor(
            top: topAnchor,
            leading: nil,
            trailing: nil,
            bottom: bottomAnchor,
            padding: .init(
                top: 9,
                left: 0,
                bottom: 0,
                right: 0
            )
        )
        messageBubbleWidth = messageBubbleView.widthAnchor.constraint(equalToConstant: 0)
        messageBubbleWidth?.isActive = true
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
    }
}
