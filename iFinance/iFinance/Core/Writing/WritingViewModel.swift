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
    private(set) var symbol: String
    
    //MARK: - Init
    init(symbol: String) {
        self.symbol = symbol
        super.init()
    }
    
    func save(data: OpinionData) {
        let value = ["id": data.id,
                     "title": data.title,
                     "date": Int(NSDate().timeIntervalSince1970),
                     "body": data.body] as [String : Any]
        
        let database = Database.database().reference()
        database.child("specificTalk").child(symbol).childByAutoId().updateChildValues(value) { _,_ in }
        
        transitionSubject.send(.done)
    }
    
    func dismiss() {
        transitionSubject.send(.dismiss)
    }
}
