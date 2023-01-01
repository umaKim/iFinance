//
//  StockDetailBuilder.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import UIKit.UIViewController

enum StockDetailTransition: Transition {
    case didTapNews(URL)
}

final class StockDetailBuilder {
    class func build(container: AppContainer, dependency: StockDetailViewModelDependency) -> Module<StockDetailTransition, UIViewController> {
        let vm = StockDetailViewModel(
            networkService: container.networkService,
            persistanceService: container.persistanceService,
            symbol: dependency.symbol
        )
        let vc = StockDetailViewController(viewModel: vm)
        return .init(viewController: vc, transitionPublisher: vm.transitionPublisher)
    }
}
