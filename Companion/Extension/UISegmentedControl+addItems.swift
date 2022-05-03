import UIKit

extension UISegmentedControl {
    func addItems(items: [String]) {
        for item in items {
            insertSegment(withTitle: item, at: numberOfSegments, animated: true)
        }
    }
}
