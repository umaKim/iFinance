//
//  WritingCoordinator.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/18.
//

import Combine
import UIKit.UINavigationController

final class WritingCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    
    var navigationController: UINavigationController
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let container: AppContainer
    private var searchedSymbol: String?
    
    init(navigationController: UINavigationController,
         conainter: AppContainer
    ){
        self.navigationController = navigationController
        self.childCoordinators = []
        self.container = conainter
    }
    
    func start() {
        let module = WritingBuilder.build()
        module
            .transitionPublisher
            .sink {[weak self] transition in
                switch transition {
                case .done:
                    //Dismiss
                    self?.dismiss()
                    
                case .dismiss:
                    self?.dismiss()
                }
            }
            .store(in: &cancellables)
        present(UINavigationController(rootViewController: module.viewController))
    }
}
