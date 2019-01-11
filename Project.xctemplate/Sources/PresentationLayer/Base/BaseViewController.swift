// ___FILEHEADER___

import UIKit

class BaseViewController: UIViewController {
    private var dimView: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame(notification:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func keyboardWillShow(frame: CGRect, duration: TimeInterval) { }
    func keyboardDidShow(frame: CGRect) { }
    func keyboardWillHide(duration: TimeInterval) { }
    func keyboardDidHide() { }
    func keyboardWillChange(frame: CGRect, duration: TimeInterval) { }
    func keyboardDidChange(frame: CGRect) { }
}

private extension BaseViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval) ?? 0
        keyboardWillShow(frame: rect, duration: duration)
    }
    @objc func keyboardDidShow(notification: NSNotification) {
        let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        keyboardDidShow(frame: rect)
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval) ?? 0
        keyboardWillHide(duration: duration)
    }
    @objc func keyboardDidHide(notification: NSNotification) {
        keyboardDidHide()
    }
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval) ?? 0
        keyboardWillChange(frame: rect, duration: duration)
    }
    @objc func keyboardDidChangeFrame(notification: NSNotification) {
        let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        keyboardDidChange(frame: rect)
    }
}

extension BaseViewController: ActivityPresenter {
    func showLoading() {
        dimView = UIView(frame: view.bounds)
        
        guard let dimView = dimView else { fatalError() }
        
        dimView.backgroundColor = UIColor.clear
        view.addSubview(dimView)
        dimView.fillSuperView()
        
        let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.startAnimating()
        
        dimView.addSubview(indicatorView)
        indicatorView.addCenterXConstraint(toView: dimView)
        indicatorView.addCenterYConstraint(toView: dimView)
        
    }
    func hideLoading() {
        dimView?.removeFromSuperview()
        dimView = nil
    }
}

extension BaseViewController: ErrorPresenter {
    func show(error: String) {
        show(actions: [UIAlertAction(title: R.string.localization.generalOk(),
                                     style: .default,
                                     handler: nil)],
             withTitle: R.string.localization.generalErrorTitle(),
             message: error,
             style: .alert)
    }
}

extension BaseViewController: MessagePresenter {
    func show(message: String?, withTitle title: String?) {
        show(actions: [UIAlertAction(title: R.string.localization.generalOk(),
                                     style: .default,
                                     handler: nil)],
             withTitle: title ?? "",
             message: message,
             style: .alert)
    }
}

extension BaseViewController: ActionsPresenter {
    func show(actions: [UIAlertAction], withTitle title: String?, message: String?, style: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true, completion: nil)
    }
}
