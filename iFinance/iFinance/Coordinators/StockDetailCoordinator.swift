//
//  StockDetailCoordinator.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//
import SafariServices
import Combine
import UIKit

final class StockDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    
    var navigationController: UINavigationController
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let container: AppContainer
//    private let myWatchListModel: MyWatchListModel
    private let symbol: String
    
    init(navigationController: UINavigationController,
         conainter: AppContainer,
         symbol: String
    ){
        self.navigationController = navigationController
        self.childCoordinators = []
        self.container = conainter
//        self.myWatchListModel = myWatchListModel
        self.symbol = symbol
    }
    
    func start() {
        let module = StockDetailBuilder.build(
            container: container,
            symbol: symbol
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

//guard let url = URL(string: viewModel.stories[indexPath.row].url) else { return }
//let vc = SFSafariViewController(url: url)
//present(vc, animated: true)
