//
//  AppContainer.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import Foundation

protocol AppContainer: AnyObject {
    var persistanceService: PersistanceService { get }
    var networkService: NetworkService { get }
    var firebaseNetworkService: FirebaseRealTimeService { get }
}

final class AppContainerImpl: AppContainer {
    let persistanceService: PersistanceService
    let networkService: NetworkService
    let firebaseNetworkService: FirebaseRealTimeService

    init() {
        self.persistanceService = PersistanceImpl()
        self.networkService = NetworkServiceImpl()
        self.firebaseNetworkService = FirebaseNetworkServiceImpl()
    }
}
