// ___FILEHEADER___

import Foundation
import UIKit
import AWSCognitoIdentityProvider

protocol MainWireframe {
    func showLoginFlow(animated: Bool)
    func showBaseFlow(animated: Bool)
    func showNewPassword(with newPasswordSource: AWSTaskCompletionSource<AWSCognitoIdentityNewPasswordRequiredDetails>)
}

protocol MainPresentation: AppLifecyclePresentation, DeeplinkPresentation, PushNotificationPresentation {
    func instantiateFlow()
}

protocol AppLifecyclePresentation {
    func appWillResignActive()
    func appDidEnterBackground()
    func appWillEnterForeground()
    func appDidBecomeActive()
    func appWillTerminate()
}
extension AppLifecyclePresentation {
    func appWillResignActive() { }
    func appDidEnterBackground() { }
    func appWillEnterForeground() { }
    func appDidBecomeActive() { }
    func appWillTerminate() { }
}

protocol DeeplinkPresentation {
    func handleOpen(url: URL, options: [UIApplication.OpenURLOptionsKey: Any]?) -> Bool
}

protocol PushNotificationPresentation {
    func didRegisterForPushNotificationsWith(_ deviceTokenData: Data)
    func didFailToRegisterForPushNotificationsWith(_ error: Error)
}
extension PushNotificationPresentation {
    func didFailToRegisterForPushNotificationsWith(_ error: Error) { }
}
