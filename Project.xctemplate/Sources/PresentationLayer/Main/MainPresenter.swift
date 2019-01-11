// ___FILEHEADER___

import Foundation
import PromiseKit
import AWSCognitoIdentityProvider

private enum FlowState {
    case none
    case login
    case base
}

final class MainPresenter {
    private let router: MainWireframe
    private let sessionService: SessionService
    private let networkService: NetworkService
    private let urlActionsService: URLActionsService
    private let authService: AuthService
    
    private var flowState: FlowState = .none
    
    init(router: MainWireframe,
         options: [UIApplication.LaunchOptionsKey: Any]? = nil,
         sessionService: SessionService,
         networkService: NetworkService,
         authService: AuthService,
         urlActionsService: URLActionsService) {
        self.router = router
        self.sessionService = sessionService
        self.networkService = networkService
        self.urlActionsService = urlActionsService
        self.authService = authService
    }
}

private extension MainPresenter {
    func update(flowState: FlowState, animated: Bool = true) {
        if self.flowState != flowState {
            self.flowState = flowState
            
            switch self.flowState {
            case .login:
                router.showLoginFlow(animated: animated)
            case .base:
                router.showBaseFlow(animated: animated)
            default:
                router.showLoginFlow(animated: animated)
            }
        }
    }
}

extension MainPresenter: MainPresentation {
    func instantiateFlow() {
        func instantiateFlow() {
            authService.accessToken().done { [weak self] _ in
                self?.update(flowState: .base)
            } .catch { [weak self] _ in
                self?.update(flowState: .login)
            }
        }
    }
}

extension MainPresenter: SessionServiceOutput {
    func sessionService(_ sessionService: SessionService, didUpdatePushNotificationsToken token: String?) {
        
    }
}

extension MainPresenter: AuthServiceOutput {
    func requireNewPassword(with newPasswordSource: AWSTaskCompletionSource<AWSCognitoIdentityNewPasswordRequiredDetails>) {
        router.showNewPassword(with: newPasswordSource)
    }
}

extension MainPresenter: DeeplinkPresentation {
    func handleOpen(url: URL, options: [UIApplication.OpenURLOptionsKey: Any]?) -> Bool {
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
        if components?.scheme == "nexus" {
            guard let host = components?.host else { return false }
            guard let action = URLAction(rawValue: host) else { return false }
            
            if let urlActionsService = urlActionsService as? URLActionBroadcaster {
                urlActionsService.broadcast(action: action)
            }
            return true
        }
        return false
    }
}

extension MainPresenter: PushNotificationPresentation {
    func didRegisterForPushNotificationsWith(_ deviceTokenData: Data) {
        let token = deviceTokenData.map { String(format: "%02.2hhx", $0) }.joined()
        debugPrint("DevicePushNotificationsToken: \(token)")
        sessionService.update(pushNotificationsToken: token)
    }
}

extension MainPresenter: PushNotificationsServiceOutput {
    func didRecieve(pushNotificationData: [String: AnyObject]?) {
    }
}
