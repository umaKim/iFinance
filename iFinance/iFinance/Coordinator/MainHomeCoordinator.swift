//
//  MainHomeCoordinator.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//
import SafariServices
import Combine
import UIKit

enum MainHomeTransition: Transition {
    case stockDetail(String)
    case opinionDetail
    case searchView
    case opinionWritingView
    case newsDetail(URL)
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
//                guard let self = self else {return }
                switch transition {
                
                case .opinionDetail:
                    break
                
                case .stockDetail(let symbol):
                    self.setupStockDetailCoordinator(symbol: symbol)
                
                case .searchView:
                    self.setupSearchCoordinator()
                    
                case .opinionWritingView:
                    break
                
                case .newsDetail(let url):
                    let vc = SFSafariViewController(url: url)
                    self.present(vc, animated: true)
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    private func setupStockDetailCoordinator(symbol: String) {
        let coordinator = StockDetailCoordinator(navigationController: navigationController,
                                                 conainter: container,
                                                 symbol: symbol)
        childCoordinators.append(coordinator)
        coordinator.didFinishPublisher
            .sink {[weak self] _ in
                self?.childCoordinators.removeAll()
                self?.didFinishSubject.send(())
            }
            .store(in: &cancellables)
        
        coordinator.start()
    }
    
    private func setupSearchCoordinator() {
        let coordinator = SearchCoordinator(navigationController: navigationController,
                                            conainter: container)
        
        childCoordinators.append(coordinator)
        coordinator
            .didFinishPublisher
            .sink { _ in
                self.childCoordinators.removeAll()
                self.didFinishSubject.send(())
            }
            .store(in: &cancellables)
        
        coordinator.start()
    }
}
