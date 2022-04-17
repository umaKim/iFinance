//
//  StockDetailBuilder.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import UIKit

enum StockDetailTransition: Transition {
    case didTapNews(URL)
}

final class StockDetailBuilder {
    class func build(container: AppContainer, symbol: String) -> Module<StockDetailTransition, UIViewController> {
        let vm = StockDetailViewModel(symbol: symbol)
        let vc = StockDetailViewController(viewModel: vm)
        return .init(viewController: vc, transitionPublisher: vm.transitionPublisher)
    }
}
