//
//  StockDetailCoordinator.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//
import SafariServices
import Combine
import UIKit

protocol StockDetailViewModelDependency {
    var symbol: String { get }
}

struct StockDetailViewModelDependencyImp: StockDetailViewModelDependency {
    var symbol: String
}

final class StockDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    
    var navigationController: UINavigationController
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let container: AppContainer
    private let dependency: StockDetailViewModelDependency
    
    init(
        navigationController: UINavigationController,
        conainter: AppContainer,
        dependency: StockDetailViewModelDependency
    ){
        self.navigationController = navigationController
        self.childCoordinators = []
        self.container = conainter
        self.dependency = dependency
    }
    
    func start() {
        let module = StockDetailBuilder.build(
            container: container,
            dependency: dependency
        )
        module
            .transitionPublisher
            .sink(receiveValue: { [weak self] transition in
                switch transition {
                case .didTapNews(let url):
                    let vc = SFSafariViewController(url: url)
                    self?.present(vc, animated: true)
                }
            })
            .store(in: &cancellables)
        push(module.viewController)
    }
}
