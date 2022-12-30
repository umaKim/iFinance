//
//  WritingViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/18.
//

import FirebaseDatabase
import Combine

enum WritingViewModelListener {
    
}

final class WritingViewModel: BaseViewModel {
    
    //MARK: - Combine
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<WritingTransition, Never>()
    
    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
    private let listenerSubject = PassthroughSubject<WritingViewModelListener, Never>()
    
    //MARK: - Model
    private let symbol: String
    private let firebaseNetworkService: FirebaseRealTimeService
    
    //MARK: - Init
    init(
        firebaseNetworkService: FirebaseRealTimeService,
        symbol: String
    ) {
        self.firebaseNetworkService = firebaseNetworkService
        self.symbol = symbol
        super.init()
    }
    
    func save(data: OpinionData) {
        firebaseNetworkService.postOpinion(symbol: symbol, data: data)
        transitionSubject.send(.done)
    }
    
    func dismiss() {
        transitionSubject.send(.dismiss)
    }
}
