//
//  OpinionsViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/13.
//

import FirebaseDatabase
import UIKit
import Combine

enum OpinionsViewModelListener {
    case reloadData
    case didTap
}

enum OpinionsViewTransition: Transition {
    case didTap(MyWatchListModel)
}

final class OpinionsViewModel: BaseViewModel {
    //MARK: - Combine
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<OpinionsViewTransition, Never>()
    
    private(set) lazy var listenerPublisher = listernSubject.eraseToAnyPublisher()
    private let listernSubject = PassthroughSubject<OpinionsViewModelListener, Never>()
    
    //MARK: - Model
    private(set) lazy var opinions: [PostContent] =  []
    
    private let firebaseNetwork: FirebaseRealTimeService
    
    //MARK: - Init
    init(firebaseNetwork: FirebaseRealTimeService) {
        self.firebaseNetwork = firebaseNetwork
        super.init()
        fetchComments()
    }
    
    private func fetchComments() {
        firebaseNetwork
            .fetchOpinions {[weak self] postContent in
                self?.opinions.append(postContent)
                DispatchQueue.main.async {
                    self?.opinions.sort { $0.date > $1.date }
                    self?.listernSubject.send(.reloadData)
                }
            }
    }
}
