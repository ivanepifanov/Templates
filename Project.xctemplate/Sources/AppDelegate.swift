// ___FILEHEADER___

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var presenter: MainPresentation?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        adoptWindow(options: launchOptions)
        return true
    }
}

private extension AppDelegate {
    func adoptWindow(options: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let window = window else { return }
        
        presenter = MainRouter(with: window).instantiateFlow(with: options)
    }
}

// MARK: - Lifecycle
extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) {
        presenter?.appWillResignActive()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        presenter?.appDidEnterBackground()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        presenter?.appWillEnterForeground()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        presenter?.appDidBecomeActive()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        presenter?.appWillTerminate()
    }
}

// MARK: - Deeplinking
extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return presenter?.handleOpen(url: url, options: options) ?? false
    }
}

// MARK: - Push Notifications
extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        presenter?.didRegisterForPushNotificationsWith(deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        presenter?.didFailToRegisterForPushNotificationsWith(error)
    }
}
