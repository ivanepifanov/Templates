// ___FILEHEADER___

import Foundation
import PromiseKit
import AWSCognitoIdentityProvider

protocol AuthService: AuthTokenProvider {
    func attach(output: AuthServiceOutput)
    
    func authenticate(username: String, password: String) -> Promise<Void>
    func deauthenticate()
    func signup(username: String, password: String) -> Promise<Void>
    func resendConfirmationCode(username: String) -> Promise<Void>
    func confirm(username: String, withCode code: String) -> Promise<Void>
    func forgotPassword(username: String) -> Promise<Void>
    func confirmForgotPassword(username: String, code: String, password: String) -> Promise<Void>
    func changePassword(currentPassword: String, proposedPassword: String) -> Promise<Void>
    func accessToken() -> Promise<String>
}

protocol AuthTokenProvider: class {
    var authToken: String? { get }
}

protocol AuthServiceOutput {
    func authServiceDidLogin()
    func authServiceDidLogout()
    func requireNewPassword(with newPasswordSource: AWSTaskCompletionSource<AWSCognitoIdentityNewPasswordRequiredDetails>)
}

extension AuthServiceOutput {
    func authServiceDidLogin() { }
    func authServiceDidLogout() { }
    func requireNewPassword(with newPasswordSource: AWSTaskCompletionSource<AWSCognitoIdentityNewPasswordRequiredDetails>) { }
}
