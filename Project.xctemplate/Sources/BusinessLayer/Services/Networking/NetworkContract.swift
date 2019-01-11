// ___FILEHEADER___

import Foundation
import PromiseKit

protocol NetworkService: class {
    func execute<Request: NetworkTargetRequestType>(_ request: Request, cancellation: NetworkRequestCancellation?) -> Promise<Void>
    func execute<Request: NetworkTargetRequestType, Value: Decodable>(_ request: Request, cancellation: NetworkRequestCancellation?, with type: Value.Type) -> Promise<Value>
}

extension NetworkService {
    func execute<Request: NetworkTargetRequestType>(_ request: Request, cancellation: NetworkRequestCancellation? = nil) -> Promise<Void> {
        return execute(request, cancellation: cancellation)
    }
    func execute<Request: NetworkTargetRequestType, Value: Decodable>(_ request: Request, cancellation: NetworkRequestCancellation? = nil, with type: Value.Type = Value.self) -> Promise<Value> {
        return execute(request, cancellation: cancellation, with: type)
    }
}

protocol NetworkTokenUpdater {
    func update(for target: NetworkTargetType) -> Promise<Void>
}
