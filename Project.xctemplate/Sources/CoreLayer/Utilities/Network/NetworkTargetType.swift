// ___FILEHEADER___

import Foundation

import Moya
import Alamofire

protocol NetworkTargetType: Moya.TargetType {
    var shouldAuthorize: Bool { get }
    var stubBehavior: StubBehavior { get }
}

extension NetworkTargetType {
    var shouldAuthorize: Bool {
        guard let authorizable = self as? AccessTokenAuthorizable else { return false }
        
        switch authorizable.authorizationType {
        case .bearer, .basic:
            return true
        default:
            return false
        }
    }
}

extension NetworkTargetType {
    var headers: [String: String]? {
        return nil
    }
}

extension NetworkTargetType {
    var stubBehavior: StubBehavior {
        return .never
    }
    
    var sampleData: Data {
        return Data()
    }
}

protocol NetworkTargetRequestType: NetworkTargetType {
    var route: NetworkTargetRoute { get }
}
extension NetworkTargetRequestType {
    var path: String {
        return route.path
    }
    var method: Moya.Method {
        return route.method
    }
    var validationType: Moya.ValidationType {
        return .successCodes
    }
}

protocol NetworkTargetFileType: NetworkTargetType {
    var location: URL { get }
}
extension NetworkTargetFileType {
    var path: String {
        return ""
    }
    var method: Moya.Method {
        return .get
    }
    var task: Moya.Task {
        return .downloadDestination { [location = location] _, _ in
            return (location, [.createIntermediateDirectories, .removePreviousFile])
        }
    }
    var validationType: Moya.ValidationType {
        return .successCodes
    }
}
