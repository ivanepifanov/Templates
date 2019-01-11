// ___FILEHEADER___

import UIKit

protocol NavigationService {
    func switchFlow(for rootViewController: UIViewController?, animated: Bool)
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool)
    func push(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func popViewController(animated: Bool)
    func popToViewController(_ viewController: UIViewController, animated: Bool)
    func popToRootViewController(animated: Bool)
}
