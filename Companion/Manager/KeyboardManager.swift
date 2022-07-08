import UIKit

final class KeyboardManager {
    // MARK: - Constants
    // MARK: Public
    static let instance = KeyboardManager()

    // MARK: - Properties
    // MARK: Public
    var serviceGranted: Bool?

    // MARK: - Init
    private init() { }

    // MARK: - API
    func getOpenKeyboardFrame(notification: Notification, NSLayoutConstraint: NSLayoutConstraint) {
        let keyboardFrame = (
            notification.userInfo?[
                UIResponder.keyboardFrameEndUserInfoKey
            ] as AnyObject
        ).cgRectValue
        if let keyboardFrame = keyboardFrame {
            NSLayoutConstraint.constant -= keyboardFrame.height
        }
    }

    func getHideKeyboardFrame(NSLayoutConstraint: NSLayoutConstraint) {
        NSLayoutConstraint.constant = 0
    }

    func getKeyboardAnimationDuration(notification: Notification, view: UIView) {
        let keyboardDuration = (
            notification.userInfo?[
                UIResponder.keyboardAnimationDurationUserInfoKey
            ] as AnyObject
        ).doubleValue
        if let keyboardDuration = keyboardDuration {
            UIView.animate(withDuration: keyboardDuration, animations: {
                view.layoutIfNeeded()
            })
        }
    }
}
