// ___FILEHEADER___

import Moya
import Result

final class NetworkProviderBuilder {
    private let queue: DispatchQueue
    private let plugins: [Moya.PluginType]
    private let lock = NSLock()
    private var providers: [Swift.ObjectIdentifier: AnyObject] = [:]
    
    init(queue: DispatchQueue, plugins: [Moya.PluginType] = []) {
        self.queue = queue
        self.plugins = plugins
    }
    
    func provider<T: NetworkTargetType>(for type: T.Type, withStubClosure stubClosure: @escaping MoyaProvider<T>.StubClosure) -> Moya.MoyaProvider<T> {
        return provider(withStubClosure: stubClosure)
    }
    
    func provider<T: NetworkTargetType>(withStubClosure stubClosure: @escaping MoyaProvider<T>.StubClosure) -> Moya.MoyaProvider<T> {
        let identifier = Swift.ObjectIdentifier(T.self)
        
        return lock.sync {
            if let provider = providers[identifier] as? NetworkProvider<T> { return provider }
            
            let provider = NetworkProvider<T>(stubClosure: stubClosure, callbackQueue: queue, plugins: plugins)
            
            providers[identifier] = provider
            
            return provider
        }
    }
}

extension NSLocking {
    func sync<T>(_ closure: () -> T) -> T {
        lock()
        defer {
            unlock()
        }
        return closure()
    }
}
