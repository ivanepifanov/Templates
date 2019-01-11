// ___FILEHEADER___

import Moya

public struct NetworkAccessTokenPlugin: PluginType {
    
    /// A closure returning the access token to be applied in the header.
    public let tokenClosure: () -> String?
    
    /**
     Initialize a new `AccessTokenPlugin`.
     
     - parameters:
     - tokenClosure: A closure returning the token to be applied in the pattern `Authorization: <AuthorizationType> <token>`
     */
    public init(tokenClosure: @escaping @autoclosure () -> String?) {
        self.tokenClosure = tokenClosure
    }
    
    /**
     Prepare a request by adding an authorization header if necessary.
     
     - parameters:
     - request: The request to modify.
     - target: The target of the request.
     - returns: The modified `URLRequest`.
     */
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let authorizable = target as? AccessTokenAuthorizable else { return request }
        guard let token = tokenClosure() else { return request }
        
        let authorizationType = authorizable.authorizationType
        
        var request = request
        
        switch authorizationType {
        case .basic, .bearer:
            guard let value = authorizationType.value else { break }
            
            let authValue = value + " " + token
            request.addValue(authValue, forHTTPHeaderField: "X-Authorization")
        case .custom(let customValue):
            let authValue = customValue + " " + token
            request.addValue(authValue, forHTTPHeaderField: "X-Authorization")
        case .none:
            break
        }
        
        return request
    }
}
