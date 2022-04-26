//
//  AppContainerMock.swift
//  iFinanceTests
//
//  Created by 김윤석 on 2022/04/26.
//

import Foundation
@testable import iFinance

class AppContainerMock: AppContainer {
    var persistanceService: PersistanceService
    
    var networkService: NetworkService
    
    var firebaseNetworkService: FirebaseRealTimeService
    
    init(
        persistanceService: PersistanceService = PersistanceMock(),
        networkService: NetworkService = NetworkMock(),
        firebaseNetworkService: FirebaseRealTimeService = FirebaseRealTimeMock()
    ){
        self.persistanceService = persistanceService
        self.networkService = networkService
        self.firebaseNetworkService = firebaseNetworkService
    }
}
