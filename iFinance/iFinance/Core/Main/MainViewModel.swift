//
//  MainCollectionViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import Combine
import Foundation

enum MainCollectionViewModelListener {
    
}

enum MyListActionNotification {
    case isEdittingButtonDidTap
}

final class MainViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<MainHomeTransition, Never>()
    
    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
    private let listenerSubject = PassthroughSubject<MainCollectionViewModelListener, Never>()
    
    private(set) var myListViewModel: MyListViewModel
    private(set) var opinionsViewModel: OpinionsViewModel
    
    //MARK: - Init
    init(
        myListViewModel: MyListViewModel,
        opinionsViewModel: OpinionsViewModel
    ) {
        self.myListViewModel = myListViewModel
        self.opinionsViewModel = opinionsViewModel
    }
}

// MARK: - Public Methods
extension MainViewModel {
    func searchButtonDidTap() {
        transitionSubject.send(.searchView)
    }
    
    func writingOpinionButtonDidTap(){
        transitionSubject.send(.opinionWritingView)
    }
    
    func stockDidTap(_ myWatchListModel: MyWatchListModel) {
        transitionSubject.send(.stockDetail(myWatchListModel.symbol))
    }
    
    func newsDidTap(news: NewsStory) {
        guard let url = URL(string: news.url) else {return }
        transitionSubject.send(.newsDetail(url))
    }
    
    func opinionDidTap() {
        transitionSubject.send(.opinionDetail)
    }
    
    func edittingDidTap() {
        myListViewModel.actionNotifier.send(.isEdittingButtonDidTap)
    }
}
