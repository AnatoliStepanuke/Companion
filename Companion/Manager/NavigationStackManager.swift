import UIKit

final class NavigationStackManager {
    // MARK: - Constants
    // MARK: Public
    static let instance = NavigationStackManager()

    // MARK: Private
    private let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    // MARK: - Properties
    // MARK: Public
    var serviceGranted: Bool?

    // MARK: - Init
    private init() { }

    // MARK: - API
    func modalPresentFullScreenTabBarViewController(identifier: String) -> UITabBarController {
        guard let tabBarViewController = mainStoryboard.instantiateViewController(
            withIdentifier: identifier
        ) as? UITabBarController else {
            fatalError("instantiateTabBarViewController failed while casting")
        }
        tabBarViewController.modalTransitionStyle = .flipHorizontal
        tabBarViewController.modalPresentationStyle = .fullScreen

        return tabBarViewController
    }

    func modalPresentFullScreenViewController(identifier: String) -> UIViewController {
        guard let viewController = mainStoryboard.instantiateViewController(
            withIdentifier: identifier
        ) as? UIViewController else {
            fatalError("instantiateViewController failed while casting")
        }
        viewController.modalTransitionStyle = .flipHorizontal
        viewController.modalPresentationStyle = .fullScreen

        return viewController
    }

    func modalPresentFullScreenViewController(viewController: UIViewController) -> UIViewController {
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .fullScreen

        return viewController
    }

    func presentCollectionViewController(collectionVC: UICollectionViewController) -> UICollectionViewController {
        return collectionVC
    }
}
