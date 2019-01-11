// ___FILEHEADER___

import Foundation
import MulticastDelegateSwift

final class URLActionsManager {
    private var outputs = MulticastDelegate<URLActionsServiceOutput>()
}

extension URLActionsManager: URLActionsService {
    func attach(output: URLActionsServiceOutput) {
        self.outputs += output
    }
}

extension URLActionsManager: URLActionBroadcaster {
    func broadcast(action: URLAction) {
        outputs |> { output in
            output.perform(action)
        }
    }
}
