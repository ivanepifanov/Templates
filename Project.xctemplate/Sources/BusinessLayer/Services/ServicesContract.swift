// ___FILEHEADER___

import Foundation

protocol Services {
    var navigationService: NavigationService { get }
    var networkService: NetworkService { get }
    var sessionService: SessionService { get }
    var authService: AuthService { get }
    var urlActionsService: URLActionsService { get }
}
