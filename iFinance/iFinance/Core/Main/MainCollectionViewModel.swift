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
    
    private(set) var myListViewModel: MyListViewModel
    private(set) var opinionsViewModel: OpinionsViewModel
    
    init(
        myListViewModel: MyListViewModel,
        opinionsViewModel: OpinionsViewModel
    ) {
        self.myListViewModel = myListViewModel
        self.opinionsViewModel = opinionsViewModel
        
    }
    
    func searchButtonDidTap() {
        transitionSubject.send(.searchView)
    }
    
    func writingOpinionButtonDidTap(){
        transitionSubject.send(.opinionWritingView)
    }
    
    func stockDidTap(_ myWatchListModel: MyWatchListModel) {
        transitionSubject.send(.stockDetail(myWatchListModel))
    }
    
    func newDidTap() {
        transitionSubject.send(.newsDetail)
    }
    
    func opinionDidTap() {
        transitionSubject.send(.opinionDetail)
    }
}
