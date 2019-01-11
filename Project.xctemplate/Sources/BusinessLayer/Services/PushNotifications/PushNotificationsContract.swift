// ___FILEHEADER___

import Foundation

protocol PushNotificationsService {
    func registerForRemoteNotifications()
    func unregisterForRemoteNotifications()
    func attach(output: PushNotificationsServiceOutput)
}

protocol PushNotificationsServiceOutput: class {
    func didRecieve(pushNotificationData: [String: AnyObject]?)
}
