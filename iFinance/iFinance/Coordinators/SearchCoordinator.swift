//
//  SearchCoordinator.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/17.
//

import UIKit.UINavigationController
import Combine

final class SearchCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    
    var navigationController: UINavigationController
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let container: AppContainer
    
    init(navigationController: UINavigationController,
         conainter: AppContainer
    ){
        self.navigationController = navigationController
        self.childCoordinators = []
        self.container = conainter
    }
    
    func start() {
        let module = SearchBuilder.build(container: container)
        module
            .transitionPublisher
            .sink {[weak self] transition in
                switch transition {
                case .didSelect(let searchResult):
                    self?.setupStockDetailCoordinator(symbol: searchResult.symbol)
                }
            }
            .store(in: &cancellables)
        
        push(module.viewController)
    }
    
    private func setupStockDetailCoordinator(symbol: String) {
        let coordinator = StockDetailCoordinator(navigationController: navigationController,
                                                 conainter: container,
                                                 symbol: symbol)
        childCoordinators.append(coordinator)
        coordinator
            .didFinishPublisher
            .sink { _ in
                
            }
            .store(in: &cancellables)
        coordinator.start()
    }
}
