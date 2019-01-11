// ___FILEHEADER___

import Foundation
import UIKit

final class NavigationManager {
    var window: UIWindow
    
    init(with window: UIWindow) {
        self.window = window
    }
}

private extension NavigationManager {
    var tabBarController: UITabBarController? {
        return window.rootViewController as? UITabBarController
    }
    var navigationController: UINavigationController? {
        var navigationController: UINavigationController?
        if let tabBarController = tabBarController {
            navigationController = tabBarController.selectedViewController as? UINavigationController
        } else {
            navigationController = window.rootViewController as? UINavigationController
        }
        while let presentedNavigationController = navigationController?.presentedViewController as? UINavigationController {
            navigationController = presentedNavigationController
        }
        return navigationController
    }
    var viewController: UIViewController? {
        var viewController: UIViewController?
        if let navigationController = navigationController {
            viewController = navigationController.topViewController
        } else {
            viewController = window.rootViewController
        }
        while let presentedViewController = navigationController?.presentedViewController {
            viewController = presentedViewController
        }
        return viewController
    }
}

extension NavigationManager: NavigationService {
    func switchFlow(for rootViewController: UIViewController?, animated: Bool) {
        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
                self?.window.rootViewController = rootViewController
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        navigationController?.setViewControllers(viewControllers, animated: animated)
    }
    func push(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        (tabBarController ?? navigationController ?? viewController)?.present(viewController, animated: animated, completion: completion)
    }
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        (tabBarController ?? navigationController ?? viewController)?.dismiss(animated: animated, completion: completion)
    }
    func popViewController(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    func popToViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.popToViewController(viewController, animated: animated)
    }
    func popToRootViewController(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }
}
