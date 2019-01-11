// ___FILEHEADER___

import Moya
import Result
import HTTPStatusCodes

struct NetworkErrorPlugin: PluginType {
    private struct Error: Decodable {
        let code: Int
        let message: String
        let title: String
        
        private enum CodingKeys: String, CodingKey {
            case code = "code"
            case message = "message"
            case title = "title"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            code = try container.decode(Int.self, forKey: .code)
            message = try container.decode(String.self, forKey: .message)
            let errorTitle = try container.decodeIfPresent(String.self, forKey: .title)
            title = errorTitle ?? R.string.localization.generalErrorTitle()
        }
    }
    
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        switch result {
        case .success:
            return result
        case .failure(let error):
            if case MoyaError.underlying(_, let response) = error {
                let updatedError: MoyaError
                
                if let response = response {
                    do {
                        let errorJSON = try response.mapJSON()
                        debugPrint("\n=========== URL ===========\n")
                        debugPrint(response.request?.url ?? "")
                        debugPrint("\n=========== BODY ===========\n")
                        debugPrint(String(data: response.request?.httpBody ?? Data(), encoding: .utf8) ?? "")
                        debugPrint("\n=========== ERROR ===========\n")
                        debugPrint(errorJSON)
                    } catch { }
                    
                    if let status = HTTPStatusCode(rawValue: response.statusCode) {
                        if status.isClientError {
                            
                            let message: NetworkError.Message?
                            let decoder = JSONDecoder.iso8601()
                            do {
                                let error = try decoder.decode(Error.self, from: response.data)
                                message = NetworkError.Message(title: error.title, message: error.message)
                            } catch {
                                message = nil
                            }
                            updatedError = .underlying(NetworkError.clientError(status: status, message: message), response)
                        } else {
                            updatedError = .underlying(NetworkError.serverError(status: status), response)
                        }
                    } else {
                        updatedError = .underlying(NetworkError(moyaError: error), response)
                    }
                } else {
                    updatedError = .underlying(NetworkError(moyaError: error), nil)
                }
                
                return .failure(updatedError)
            }
            
            return .failure(.underlying(NetworkError.unknown, nil))
        }
    }
}
