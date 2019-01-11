//  ___FILEHEADER___

import UIKit

final class ___FILEBASENAME___: ___VARIABLE_baseRouter___ {
    func instantiateScreen(output: ___VARIABLE_productName___NavigationOutput? = nil) -> ___VARIABLE_baseView___ {
        let storyboard = UIStoryboard(name: "___VARIABLE_productName___Navigation", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? ___VARIABLE_productName___NavigationController
            else { fatalError("___VARIABLE_productName___NavigationController not found") }
        
        let presenter = ___VARIABLE_productName___NavigationPresenter(router: self, view: navigationController, output: output)
        navigationController.attach(presenter: presenter)
        
        navigationController.viewControllers = []
        
        return navigationController
    }
}

extension ___FILEBASENAME___: ___VARIABLE_productName___NavigationWireframe {
}
