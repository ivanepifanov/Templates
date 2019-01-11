// ___FILEHEADER___

import Foundation
import Moya

enum AuthServicesRequest {
    case login(login: String, password: String)
}

extension AuthServicesRequest: NetworkTargetRequestType {
    var baseURL: URL {
        return Configuration.Backend.parameters.host
    }
    var route: NetworkTargetRoute {
        switch self {
        case .login:
            return .post("login")
        }
    }
    var task: Moya.Task {
        switch self {
        case .login(let login, let password):
            return .requestParameters(parameters: ["login": login,
                                                   "password": password],
                                      encoding: JSONEncoding.default)
        }
    }
}
