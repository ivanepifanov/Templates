// ___FILEHEADER___

import UIKit
import UserNotifications
import MulticastDelegateSwift

final class PushNotificationsManager: NSObject {
    
    static let shared = PushNotificationsManager()
    
    private var outputs = MulticastDelegate<PushNotificationsServiceOutput>()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

extension PushNotificationsManager: PushNotificationsService {
    func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
            guard granted else { return }
            
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        }
    }
    
    func unregisterForRemoteNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func attach(output: PushNotificationsServiceOutput) {
        self.outputs += output
    }
}

extension PushNotificationsManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if let pushData = response.notification.request.content.userInfo as? [String: AnyObject] {
            outputs |> { output in
                output.didRecieve(pushNotificationData: pushData)
            }
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
