// ___FILEHEADER___

import Foundation

protocol SessionService: class {
    
    var pushNotificationsToken: String? { get }
    
    func update(pushNotificationsToken: String)
    
    func attach(output: SessionServiceOutput)
}

protocol SessionServiceOutput: class {
    func sessionService(_ sessionService: SessionService, didUpdatePushNotificationsToken token: String?)
}
extension SessionServiceOutput {
    func sessionService(_ sessionService: SessionService, didUpdatePushNotificationsToken token: String?) { }
}
