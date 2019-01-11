// ___FILEHEADER___

import HTTPStatusCodes
import Moya
import PromiseKit

enum NetworkError: Error {
    struct Context {
        let status: HTTPStatusCode
        let underlayingError: Error?
    }
    
    struct Message {
        let title: String
        let message: String
    }
    
    case unknown
    case cancelled
    case connection
    case server(context: Context)
    case client(context: Context, message: Message?)
    case decoding(context: Context)
    
    var context: Context? {
        switch self {
        case .unknown: return nil
        case .cancelled: return nil
        case .connection: return nil
        case .server(let context): return context
        case .client(let context, _): return context
        case .decoding(let context): return context
        }
    }
}

extension NetworkError {
    static func serverError(status: HTTPStatusCode) -> NetworkError {
        return .server(context: Context(status: status, underlayingError: nil))
    }
    
    static func clientError(status: HTTPStatusCode, message: Message?) -> NetworkError {
        return .client(context: Context(status: status, underlayingError: nil), message: message)
    }
    
    static func decodingError(status: HTTPStatusCode, error: Error) -> NetworkError {
        return .decoding(context: Context(status: status, underlayingError: error))
    }
}

extension NetworkError {
    init(moyaError: MoyaError) {
        switch moyaError {
        case .underlying(let underlaying, _):
            self.init(error: underlaying)
        default:
            self = .unknown
        }
    }
    
    init(error: Swift.Error) {
        if error.isCancelled {
            self = .cancelled
        } else if ((error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorNetworkConnectionLost)
            || ((error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorCannotConnectToHost)
            || ((error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorNotConnectedToInternet)
            || ((error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorTimedOut) {
            self = .connection
        } else if let networkError = error as? NetworkError {
            self = networkError
        } else {
            self = .unknown
        }
    }
}

// MARK: - CancellableError
extension NetworkError: PromiseKit.CancellableError {
    var isCancelled: Bool {
        return self == .cancelled
    }
}

// MARK: - Equatable
extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown): return true
        case (.cancelled, .cancelled): return true
        case (.connection, .connection): return true
        case (.server, .server): return true
        case (.client, .client): return true
        case (.decoding, .decoding): return true
        default: return false
        }
    }
}
