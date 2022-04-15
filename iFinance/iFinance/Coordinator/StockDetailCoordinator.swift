//
//  StockDetailCoordinator.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import Combine
import UIKit

final class StockDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    
    var navigationController: UINavigationController
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let container: AppContainer
    private let myWatchListModel: MyWatchListModel
    
    init(navigationController: UINavigationController,
         conainter: AppContainer,
         myWatchListModel: MyWatchListModel
    ){
        self.navigationController = navigationController
        self.childCoordinators = []
        self.container = conainter
        self.myWatchListModel = myWatchListModel
    }
    
    func start() {
        let module = StockDetailBuilder.build(container: container,
                                              myWatchListModel: myWatchListModel)
        module
            .transitionPublisher
            .sink(receiveValue: { [weak self] transition in
                switch transition {
                
                }
            })
            .store(in: &cancellables)
        push(module.viewController)
    }
}


