//  ___FILEHEADER___

import UIKit

final class ___FILEBASENAME___: ___VARIABLE_baseView___ {
    private var presenter: ___VARIABLE_productName___NavigationPresentation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoad()
    }
}

private extension ___FILEBASENAME___ {
    func setupUI() {
    }
}

extension ___FILEBASENAME___: ___VARIABLE_productName___NavigationView {
}

private extension ___FILEBASENAME___ {
}

extension ___FILEBASENAME___: ___VARIABLE_productName___NavigationViewInput {
    func attach(presenter: ___VARIABLE_productName___NavigationPresentation) {
        self.presenter = presenter
    }
}
