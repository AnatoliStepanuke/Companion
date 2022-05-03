import UIKit

extension UIButton {
    func roundedButton() {
        layer.cornerRadius = 16
    }

    func backgroundColorButton() {
        backgroundColor = AppColor.whiteColor
    }

    func fontColorButton() {
        tintColor = AppColor.fontColor
    }
}
