// ___FILEHEADER___

import Foundation
import UIKit
import HockeySDK
import Moya
import AWSCore
import AWSCognitoIdentityProvider

final class MainRouter {
    let services: Services
    
    init(with window: UIWindow) {
        services = MainServices(with: window)
        configureHockeyApp()
        configureAWS()
    }
    
    func instantiateFlow(with options: [UIApplication.LaunchOptionsKey: Any]?) -> MainPresentation {
        
        let presenter = MainPresenter(router: self,
                                      options: options,
                                      sessionService: services.sessionService,
                                      networkService: services.networkService,
                                      authService: services.authService,
                                      urlActionsService: services.urlActionsService)
        services.authService.attach(output: presenter)
        services.sessionService.attach(output: presenter)
        PushNotificationsManager.shared.attach(output: presenter)
        
        presenter.instantiateFlow()
        
        return presenter
    }
}

extension MainRouter: MainWireframe {
    func showLoginFlow(animated: Bool) {
        //TODO: Add auth flow
        
    }
    func showBaseFlow(animated: Bool) {
        //TODO: Add base flow
    }
    func showNewPassword(with newPasswordSource: AWSTaskCompletionSource<AWSCognitoIdentityNewPasswordRequiredDetails>) {
        //TODO: Add new password flow
    }
}

private extension MainRouter {
    func configureHockeyApp() {
        BITHockeyManager.shared().configure(withIdentifier: "ReplacehockeyAppID")
        #if !DEBUG
        BITHockeyManager.shared().crashManager.crashManagerStatus = .autoSend
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        #endif
        BITHockeyManager.shared().updateManager.isCheckForUpdateOnLaunch = false
        BITHockeyManager.shared().start()
    }
    
    func configureAWS() {
        #if DEBUG
        AWSDDLog.sharedInstance.logLevel = .debug
        #endif
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
    }
}

// MARK: -
private struct MainServices: Services {
    let networkService: NetworkService
    let navigationService: NavigationService
    let sessionService: SessionService
    let authService: AuthService
    let urlActionsService: URLActionsService
    
    init(with window: UIWindow) {
        navigationService = NavigationManager(with: window)
        urlActionsService = URLActionsManager()
        
        let sessionService = SessionManager()
        self.sessionService = sessionService
        
        let authService = AuthManager()
        self.authService = authService
        
        authService.attach(output: sessionService)
        
        networkService = NetworkManager(with: [NetworkLoggerPlugin(verbose: true),
                                               NetworkErrorPlugin(),
                                               NetworkAccessTokenPlugin(tokenClosure: authService.authToken)],
                                        tokenUpdater: authService)
    }
}
