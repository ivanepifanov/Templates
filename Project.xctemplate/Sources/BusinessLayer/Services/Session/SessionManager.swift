// ___FILEHEADER___

import Foundation
import KeychainAccess
import MulticastDelegateSwift

final class SessionManager {
    private var outputs = MulticastDelegate<SessionServiceOutput>()
    
    var pushNotificationsToken: String? {
        didSet {
            outputs |> { output in
                output.sessionService(self, didUpdatePushNotificationsToken: pushNotificationsToken)
            }
        }
    }
}

extension SessionManager: SessionService {
    func update(pushNotificationsToken: String) {
        self.pushNotificationsToken = pushNotificationsToken
    }
    
    func attach(output: SessionServiceOutput) {
        self.outputs += output
    }
}

extension SessionManager: AuthServiceOutput {
    func authServiceDidLogout() {
    }
}
