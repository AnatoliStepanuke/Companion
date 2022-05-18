import UIKit

extension UIImageView {
    enum Constants {
        static let imageCache = NSCache<NSString, UIImage>()
    }
}
