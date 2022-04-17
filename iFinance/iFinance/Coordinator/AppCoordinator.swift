//
//  AppCoordinator.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import UIKit
import Combine

final class AppCoordinator: Coordinator {

    var window: UIWindow
    var navigationController: UINavigationController
    let container: AppContainer
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    var childCoordinators: [Coordinator] = []
    
    private var cancellables = Set<AnyCancellable>()

    init(window: UIWindow,
         navigationController: UINavigationController = UINavigationController(),
         container: AppContainer) {
        self.window = window
        self.navigationController = navigationController
        self.container = container
        
        self.window.overrideUserInterfaceStyle = .dark
    }

    func start() {
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        mainFlow()
    }
    
    private func mainFlow() {
        let mainCoordinator = MainHomeCoordinator(navigationController: navigationController,
                                                  conainter: container)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.didFinishPublisher
            .sink { [unowned self] in
                removeChild(coordinator: mainCoordinator)
            }
            .store(in: &cancellables)
        mainCoordinator.start()
    }
}
