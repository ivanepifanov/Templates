// ___FILEHEADER___

import Moya
import PromiseKit
import Alamofire

enum NetworkHttpHeader: String {
    case contentType = "Content-Type"
    case acceptLanguage = "Accept-Language"
    case authorization = "X-Authorization"
}

extension MoyaError: PromiseKit.CancellableError {
    public var isCancelled: Bool {
        switch self {
        case .underlying(let error, _):
            return error.isCancelled
        default: return false
        }
    }
}

final class NetworkProvider<Target: NetworkTargetType>: Moya.MoyaProvider<Target> {
    override init(endpointClosure: @escaping EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
                  requestClosure: @escaping RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
                  stubClosure: @escaping StubClosure = MoyaProvider<Target>.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  manager: Manager = NetworkProvider<Target>.defaultManager(),
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {
        
        super.init(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            callbackQueue: callbackQueue,
            manager: manager,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }
}

private extension NetworkProvider {
    static func defaultManager() -> Moya.Manager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.httpAdditionalHeaders?.removeValue(forKey: NetworkHttpHeader.acceptLanguage.rawValue)
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        
        return manager
    }
}
