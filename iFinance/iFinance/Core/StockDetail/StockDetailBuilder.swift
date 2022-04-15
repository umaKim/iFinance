//
//  StockDetailBuilder.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import UIKit

enum StockDetailTransition: Transition {
    
}

final class StockDetailBuilder {
    class func build(container: AppContainer, myWatchListModel: MyWatchListModel) -> Module<StockDetailTransition, UIViewController> {
        let vm = StockDetailViewModel(myWatchListModel: myWatchListModel)
        let vc = StockDetailViewController(viewModel: vm)
        return .init(viewController: vc, transitionPublisher: vm.transitionPublisher)
    }
}
