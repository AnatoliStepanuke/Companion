import UIKit

extension UICollectionView {
    func scrollToLastItem(
        collectionView: UICollectionView,
        position: UICollectionView.ScrollPosition,
        animated: Bool
    ) {
        let lastSection = collectionView.numberOfSections - 1
        let lastRow = collectionView.numberOfItems(inSection: lastSection)
        let indexPath = IndexPath(row: lastRow - 1, section: lastSection)
        collectionView.scrollToItem(at: indexPath, at: position, animated: animated)
    }

    func customContentViewDistanceSafeArea(
        collectionView: UICollectionView,
        top: CGFloat,
        left: CGFloat,
        right: CGFloat,
        bottom: CGFloat
    ) {
        collectionView.contentInset = UIEdgeInsets(
            top: top,
            left: left,
            bottom: bottom,
            right: right
        )
    }

    func customScrollViewDistanceSafeArea(
        collectionView: UICollectionView,
        top: CGFloat,
        left: CGFloat,
        right: CGFloat,
        bottom: CGFloat
    ) {
        collectionView.scrollIndicatorInsets = UIEdgeInsets(
            top: top,
            left: left,
            bottom: bottom,
            right: right
        )
    }
}
