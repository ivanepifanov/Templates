// ___FILEHEADER___

import UIKit

protocol BasePresentation: class {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
}

extension BasePresentation {
    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewWillDisappear() {}
}

protocol ActivityPresenter: class {
    func showLoading()
    func hideLoading()
}

protocol ErrorPresenter: class {
    func show(error: String)
}

protocol MessagePresenter {
    func show(message: String?, withTitle title: String?)
}

extension MessagePresenter {
    func show(message: String?, withTitle title: String? = nil) {
        show(message: message, withTitle: title)
    }
}

protocol ActionsPresenter: class {
    func show(actions: [UIAlertAction], withTitle title: String?, message: String?, style: UIAlertController.Style)
}

extension ActionsPresenter {
    func show(actions: [UIAlertAction], withTitle title: String? = nil, message: String? = nil, style: UIAlertController.Style = .actionSheet) {
        show(actions: actions, withTitle: title, message: message, style: style)
    }
}
