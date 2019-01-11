//  ___FILEHEADER___

import UIKit

final class ___FILEBASENAME___: ___VARIABLE_baseView___ {
    private var presenter: ___VARIABLE_productName___Presentation?
    
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

extension ___FILEBASENAME___: ___VARIABLE_productName___View {
}

private extension ___FILEBASENAME___ {
}

extension ___FILEBASENAME___: ___VARIABLE_productName___ViewInput {
    func attach(presenter: ___VARIABLE_productName___Presentation) {
        self.presenter = presenter
    }
}
