// ___FILEHEADER___

import Foundation

protocol NetworkRequestCancellation {
    var isCancelled: Bool { get }
    
    func register(handler: @escaping () -> Void)
}

extension CancellationToken: NetworkRequestCancellation {
    var isCancelled: Bool {
        return isCancelling
    }
    
    func register(handler: @escaping () -> Void) {
        register(handler)
    }
}
