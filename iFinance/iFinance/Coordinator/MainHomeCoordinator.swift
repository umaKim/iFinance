//
//  MainHomeCoordinator.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//
import Combine
import UIKit

enum MainHomeTransition: Transition {
    case stockDetail(MyWatchListModel)
    case opinionDetail
    case searchView
    case opinionWritingView
    case newsDetail
}

final class MainHomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    
    var navigationController: UINavigationController
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable>
    
    let container: AppContainer
    
    init(navigationController: UINavigationController, conainter: AppContainer){
        self.navigationController = navigationController
        self.childCoordinators = []
        self.container = conainter
        self.cancellables = .init()
        
    }
    
    func start() {
        let module = MainHomeBuilder.build()
        module
            .transitionPublisher
            .sink { transition in
                switch transition {
                case .opinionDetail:
                    break
                case .stockDetail(let myWatchListModel):
                    self.setupStockDetailCoordinator(myWatchListModel: myWatchListModel)
                case .searchView:
                    break
                case .opinionWritingView:
                    break
                case .newsDetail:
                    break
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    private func setupStockDetailCoordinator(myWatchListModel: MyWatchListModel) {
        let coordinator = StockDetailCoordinator(navigationController: navigationController,
                                                 conainter: container,
                                                 myWatchListModel: myWatchListModel)
        childCoordinators.append(coordinator)
        coordinator.didFinishPublisher
            .sink {[weak self] _ in
                self?.childCoordinators.removeAll()
                self?.didFinishSubject.send(())
            }
            .store(in: &cancellables)
        
        coordinator.start()
    }
}
