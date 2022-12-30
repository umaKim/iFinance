//
//  MainHomeBuilder.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import UIKit.UIViewController

final class MainHomeBuilder {
    class func build(container: AppContainer) -> Module<MainHomeTransition, UIViewController> {
        let viewModel = MainViewModel(
            myListViewModel:
                MyListViewModel(
                    networkService: container.networkService,
                    persistanceService: container.persistanceService
                ),
            opinionsViewModel:
                OpinionsViewModel(firebaseNetwork: container.firebaseNetworkService)
        )
        let vc = MainViewController(viewModel: viewModel)
        return .init(viewController: vc, transitionPublisher: viewModel.transitionPublisher)
    }
}
