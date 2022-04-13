//
//  MainCollectionViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import Combine

class MainCollectionViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<MainHomeTransition, Never>()
    
    func searchButtonDidTap() {
        transitionSubject.send(.moveToSearchView)
    }
    
    func writingOpinionButtonDidTap(){
        transitionSubject.send(.moveToOpinionWritingView)
    }
    
    func stockDidTap() {
        transitionSubject.send(.moveToStockDetail)
    }
    
    func newDidTap() {
        transitionSubject.send(.moveToNewsDetail)
    }
    
    func opinionDidTap() {
        transitionSubject.send(.moveToOpinionDetail)
    }
}