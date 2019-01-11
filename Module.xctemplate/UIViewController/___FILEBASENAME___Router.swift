//  ___FILEHEADER___

import UIKit

final class ___FILEBASENAME___ {
    func instantiateScreen(output: ___VARIABLE_productName___Output? = nil) -> ___VARIABLE_baseView___ {
        let storyboard = UIStoryboard(name: "___VARIABLE_productName___", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? ___VARIABLE_productName___ViewController
            else { fatalError("___VARIABLE_productName___ViewController not found") }
        
        let presenter = ___VARIABLE_productName___Presenter(router: self, view: viewController, output: output)
        viewController.attach(presenter: presenter)
        return viewController
    }
}

extension ___FILEBASENAME___: ___VARIABLE_productName___Wireframe {
}
