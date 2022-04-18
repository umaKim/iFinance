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
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<WritingTransition, Never>()
    
    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
    private let listenerSubject = PassthroughSubject<WritingViewModelListener, Never>()
    
    private(set) var symbol = ""
    
    private let database = Database.database().reference()
    
    func save() {
        transitionSubject.send(.done)
    }
    
    func dismiss() {
        transitionSubject.send(.dismiss)
    }
}
