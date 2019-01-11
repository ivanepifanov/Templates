// ___FILEHEADER___

import Foundation

protocol URLActionsService {
    func attach(output: URLActionsServiceOutput)
}

protocol URLActionsServiceOutput: class {
    func perform(_ action: URLAction)
}

enum URLAction: String {
    case sampleAction = "sample_action"
}

protocol URLActionBroadcaster {
    func broadcast(action: URLAction)
}
