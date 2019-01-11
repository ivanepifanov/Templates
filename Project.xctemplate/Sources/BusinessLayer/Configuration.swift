// ___FILEHEADER___

import Foundation

struct Configuration {
    struct Backend {
        struct Parameters {
            let host: URL
            var identifier: String {
                return host.absoluteString
            }
        }
        
        static let parameters: Parameters = {
            if let serverStr = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as? String, let url = URL(string: serverStr) {
                return Parameters(host: url)
            } else {
                fatalError("Unable to config server url")
            }
        }()
    }
}
