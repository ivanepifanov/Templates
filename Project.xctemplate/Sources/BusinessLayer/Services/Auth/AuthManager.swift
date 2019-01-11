// ___FILEHEADER___

import Foundation
import AWSCognitoIdentityProvider
import PromiseKit
import Moya
import MulticastDelegateSwift

private extension Error {
    func translatedError() -> NSError {
        var userInfo = (self as NSError).userInfo
        if userInfo[NSLocalizedDescriptionKey] == nil {
            let code = (self as NSError).code
            let message = userInfo["message"] as? String ?? R.string.localization.generalErrorMessage()
            userInfo[NSLocalizedDescriptionKey] = message
            return NSError(domain: "auth", code: code, userInfo: userInfo)
        } else {
            return self as NSError
        }
    }
}

private extension NSError {
    static func generalError() -> NSError {
        return NSError(domain: "auth",
                       code: -1,
                       userInfo: [NSLocalizedDescriptionKey: R.string.localization.generalErrorMessage()])
    }
}

final class AuthManager: NSObject, AuthService, AuthTokenProvider {
    
    private var outputs = MulticastDelegate<AuthServiceOutput>()
    
    func attach(output: AuthServiceOutput) {
        self.outputs += output
    }
    
    private (set) var authToken: String?

    private lazy var pool: AWSCognitoIdentityUserPool = {
        let pool = AWSCognitoIdentityUserPool.default()
        pool.delegate = self
        return pool
    }()
    
    func authenticate(username: String, password: String) -> Promise<Void> {
        return Promise { seal in
            if pool.currentUser()?.isSignedIn == true {
                pool.currentUser()?.signOutAndClearLastKnownUser()
            }
            let user = pool.getUser(username)
            user.getSession(username, password: password, validationData: nil).continueWith { [weak self] task -> Void in
                if let error = task.error?.translatedError() {
                    seal.reject(error)
                } else {
                    guard let accessToken = task.result?.accessToken?.tokenString else { return seal.reject(NSError.generalError()) }
                    
                    self?.authToken = accessToken
                    if let outputs = self?.outputs {
                        outputs |> { output in
                            output.authServiceDidLogin()
                        }
                    }
                    seal.fulfill(())
                }
            }
        }
    }
    
    func deauthenticate() {
        if pool.currentUser()?.isSignedIn ?? false {
            pool.currentUser()?.signOutAndClearLastKnownUser()
        } else {
            pool.clearLastKnownUser()
        }
        outputs |> { output in
            output.authServiceDidLogout()
        }
    }
    
    func signup(username: String, password: String) -> Promise<Void> {
        return Promise { seal in
            if let currentUser = pool.currentUser(), currentUser.isSignedIn == true {
                currentUser.signOutAndClearLastKnownUser()
            }
            pool.signUp(username, password: password, userAttributes: nil, validationData: nil).continueWith { task -> Void in
                if let error = task.error?.translatedError() {
                    seal.reject(error)
                } else {
                    seal.fulfill(())
                }
            }
        }
    }
    
    func resendConfirmationCode(username: String) -> Promise<Void> {
        return Promise { seal in
            self.pool.getUser(username).resendConfirmationCode().continueWith { task -> Void in
                if let error = task.error?.translatedError() {
                    seal.reject(error)
                } else {
                    seal.fulfill(())
                }
            }
        }
    }
    
    func confirm(username: String, withCode code: String) -> Promise<Void> {
        return Promise { seal in
            pool.getUser(username).confirmSignUp(code).continueWith { task -> Void in
                if let error = task.error?.translatedError() {
                    seal.reject(error)
                } else {
                    seal.fulfill(())
                }
            }
        }
    }
    
    func forgotPassword(username: String) -> Promise<Void> {
        return Promise { seal in
            pool.getUser(username).forgotPassword().continueWith { task -> Void in
                if let error = task.error?.translatedError() {
                    seal.reject(error)
                } else {
                    seal.fulfill(())
                }
            }
        }
    }
    
    func confirmForgotPassword(username: String, code: String, password: String) -> Promise<Void> {
        return Promise { seal in
            pool.getUser(username).confirmForgotPassword(code, password: password).continueWith { task -> Void in
                if let error = task.error?.translatedError() {
                    seal.reject(error)
                } else {
                    seal.fulfill(())
                }
            }
        }
    }
    
    func changePassword(currentPassword: String, proposedPassword: String) -> Promise<Void> {
        return Promise { seal in
            guard let user = pool.currentUser() else { return seal.reject(NSError.generalError()) }
            
            user.changePassword(currentPassword, proposedPassword: proposedPassword).continueWith { task -> Void in
                if let error = task.error?.translatedError() {
                    seal.reject(error)
                } else {
                    seal.fulfill(())
                }
            }
        }
    }
    
    func accessToken() -> Promise<String> {
        return Promise { seal in
            guard let user = pool.currentUser() else { return seal.reject(NSError.generalError()) }
            
            user.getSession().continueWith { [weak self] task -> Void in
                if let error = task.error?.translatedError() {
                    return seal.reject(error)
                }
                
                guard let accessToken = task.result?.accessToken?.tokenString else { return seal.reject(NSError.generalError()) }
                
                self?.authToken = accessToken
                seal.fulfill(accessToken)
            }
        }
    }
}

extension AuthManager: NetworkTokenUpdater {
    func update(for target: NetworkTargetType) -> Promise<Void> {
        guard let authorizable = target as? AccessTokenAuthorizable else { return .value(()) }
        
        let authorizationType = authorizable.authorizationType
        switch authorizationType {
        case .basic, .bearer, .custom:
            return Promise { seal in
                accessToken().done { _ in
                    seal.fulfill(())
                }.catch { error in
                    seal.reject(error)
                }
            }
        case .none:
            return .value(())
        }
    }
}

extension AuthManager: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    func startNewPasswordRequired() -> AWSCognitoIdentityNewPasswordRequired {
        return self
    }
}
extension AuthManager: AWSCognitoIdentityNewPasswordRequired {
    func getNewPasswordDetails(_ newPasswordRequiredInput: AWSCognitoIdentityNewPasswordRequiredInput, newPasswordRequiredCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityNewPasswordRequiredDetails>) {
        DispatchQueue.main.async { [weak self] in
            if let outputs = self?.outputs {
                outputs |> { output in
                    output.requireNewPassword(with: newPasswordRequiredCompletionSource)
                }
            }
        }
    }
    func didCompleteNewPasswordStepWithError(_ error: Error?) {
        if let error = error {
            debugPrint("didCompleteNewPasswordStepWithError: \(error.localizedDescription)")
        }
    }
}
