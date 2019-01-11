// ___FILEHEADER___

import Moya
import PromiseKit
import HTTPStatusCodes

final class NetworkManager {
    
    private let providerBuilder: NetworkProviderBuilder
    private let tokenUpdater: NetworkTokenUpdater
    private let queue: DispatchQueue = .global(qos: .userInitiated)
    
    init(with plugins: [Moya.PluginType], tokenUpdater: NetworkTokenUpdater) {
        self.providerBuilder = NetworkProviderBuilder(queue: .global(qos: .default), plugins: plugins)
        self.tokenUpdater = tokenUpdater
    }
}

extension NetworkManager: NetworkService {
    func execute<Request: NetworkTargetRequestType>(_ request: Request, cancellation: NetworkRequestCancellation?) -> Promise<Void> {
        let progress = NetworkProgress.request()
        let promise: Promise<Void> = Promise { resolver in
            guard cancellation == nil || cancellation?.isCancelled == false else { throw NetworkError.cancelled }
            
            tokenUpdater.update(for: request).done { [weak self] in
                self?.queue.async { [weak self] in
                    guard let provider = self?.providerBuilder.provider(for: Request.self,
                                                                        withStubClosure: { target -> StubBehavior in
                                                                            return target.stubBehavior
                    }) else { return }
                    
                    let task = provider.request(request, callbackQueue: self?.queue, progress: progress?.report) { result in
                        do {
                            switch result {
                            case .success:
                                resolver.fulfill(())
                            case .failure(let error):
                                throw NetworkError(moyaError: error)
                            }
                        } catch {
                            resolver.reject(error)
                        }
                    }
                    
                    cancellation?.register(handler: task.cancel)
                }
            }.catch({ error in
                resolver.reject(error)
            })
        }
        
        return progress?.inspect(promise: promise, on: queue) ?? promise
    }
    
    func execute<Request: NetworkTargetRequestType, Value: Decodable>(_ request: Request, cancellation: NetworkRequestCancellation?, with type: Value.Type) -> Promise<Value> {
        let progress = NetworkProgress.request()
        let promise: Promise<Value> = Promise { resolver in
            guard cancellation == nil || cancellation?.isCancelled == false else { throw NetworkError.cancelled }
            
            tokenUpdater.update(for: request).done { [weak self] in
                self?.queue.async { [weak self] in
                    guard let provider = self?.providerBuilder.provider(for: Request.self,
                                                                        withStubClosure: { target -> StubBehavior in
                                                                            return target.stubBehavior
                    }) else { return }
                    
                    let task = provider.request(request, callbackQueue: self?.queue, progress: progress?.report) { result in
                        do {
                            switch result {
                            case .success(let response):
                                guard let status = HTTPStatusCode(rawValue: response.statusCode) else { throw NetworkError.unknown }
                                
                                func decode<T: Decodable>(_ type: T.Type = T.self) throws -> T {
                                    let decoder = JSONDecoder.iso8601()
                                    return try decoder.decode(T.self, from: response.data)
                                }
                                
                                do {
                                    resolver.fulfill(try decode(Value.self))
                                } catch {
                                    throw NetworkError.decodingError(status: status, error: error)
                                }
                            case .failure(let error):
                                throw NetworkError(moyaError: error)
                            }
                        } catch {
                            resolver.reject(error)
                        }
                    }
                    
                    cancellation?.register(handler: task.cancel)
                }
            } .catch({ error in
                resolver.reject(error)
            })
        }
        return progress?.inspect(promise: promise, on: queue) ?? promise
    }
}
