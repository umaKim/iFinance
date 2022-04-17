//
//  AppContainer.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import Foundation

protocol AppContainer: AnyObject {
//    var authService: AuthService { get }
//    var userService: UserService { get }
//    var appSettingsService: AppSettingsService { get }
    var persistanceService: PersistanceService { get }
    var networkService: NetworkService { get }
}

final class AppContainerImpl: AppContainer {
//    let authService: AuthService
//    let userService: UserService
//    let appSettingsService: AppSettingsService
    
    let persistanceService: PersistanceService
    let networkService: NetworkService

    init() {
        let network = NetworkServiceImpl()
        let appConfiguration = AppConfigurationImpl()

//        let authService = AuthServiceImpl(network: network)
//        self.authService = authService

//        let userService = UserServiceImpl(configuration: appConfiguration)
//        self.userService = userService

//        let appSettingsService = AppSettingsServiceImpl()
//        self.appSettingsService = appSettingsService
        
        self.persistanceService = PersistanceImpl()
        
        self.networkService = NetworkServiceImpl()
    }
}

protocol PersistanceService {
    
}

final class PersistanceImpl: PersistanceService {
    
}

protocol NetworkService {
    
}

final class NetworkServiceImpl: NetworkService {
    
}
