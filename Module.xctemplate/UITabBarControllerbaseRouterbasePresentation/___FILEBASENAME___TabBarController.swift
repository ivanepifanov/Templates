//  ___FILEHEADER___

import UIKit

final class ___FILEBASENAME___: ___VARIABLE_baseView___ {
    private var presenter: ___VARIABLE_productName___TabBarPresentation?
    
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

extension ___FILEBASENAME___: ___VARIABLE_productName___TabBarView {
}

private extension ___FILEBASENAME___ {
}

extension ___FILEBASENAME___: ___VARIABLE_productName___TabBarViewInput {
    func attach(presenter: ___VARIABLE_productName___TabBarPresentation) {
        self.presenter = presenter
    }
}
