//
//  WritingCoordinator.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/18.
//

import Combine
import UIKit.UINavigationController

protocol WritingViewModelDependency {
    var symbol: String { get }
}

struct WritingViewModelDependencyImp: WritingViewModelDependency {
    var symbol: String
}

final class WritingCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    
    var navigationController: UINavigationController
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let container: AppContainer
    private let dependency: WritingViewModelDependency
    
    init(
        navigationController: UINavigationController,
        conainter: AppContainer,
        dependency: WritingViewModelDependency
    ){
        self.navigationController = navigationController
        self.childCoordinators = []
        self.container = conainter
        self.dependency = dependency
    }
    
    func start() {
        let module = WritingBuilder.build(
            container: container,
            dependncy: dependency
        )
        module
            .transitionPublisher
            .sink {[weak self] transition in
                switch transition {
                case .done:
                    self?.dismiss()
                    
                case .dismiss:
                    self?.dismiss()
                }
            }
            .store(in: &cancellables)
        present(UINavigationController(rootViewController: module.viewController))
    }
}
