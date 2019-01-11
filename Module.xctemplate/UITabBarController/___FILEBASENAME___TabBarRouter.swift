//  ___FILEHEADER___

import UIKit

final class ___FILEBASENAME___ {
    func instantiateScreen(output: ___VARIABLE_productName___TabBarOutput? = nil) -> ___VARIABLE_baseView___ {
        let storyboard = UIStoryboard(name: "___VARIABLE_productName___TabBar", bundle: nil)
        guard let tabBarController = storyboard.instantiateInitialViewController() as? ___VARIABLE_productName___TabBarController
            else { fatalError("___VARIABLE_productName___NavigationController not found") }
        
        let presenter = ___VARIABLE_productName___TabBarPresenter(router: self, view: tabBarController, output: output)
        tabBarController.attach(presenter: presenter)
        
        tabBarController.setViewControllers([], animated: false)
        
        return tabBarController
    }
}

extension ___FILEBASENAME___: ___VARIABLE_productName___TabBarWireframe {
}
