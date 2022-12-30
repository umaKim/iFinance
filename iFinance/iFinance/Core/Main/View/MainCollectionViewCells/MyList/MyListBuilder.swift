//
//  MyListBuilder.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/19.
//

import UIKit

enum MyListViewTransition: Transition {
    case didTap(MyWatchListModel)
}

final class MyListBuilder {
    class func build(container: AppContainer) -> Module<MyListViewTransition, UIViewController> {
        let vm = MyListViewModel(
            networkService: container.networkService,
            persistanceService: container.persistanceService
        )
        let vc = MyListViewController(viewModel: vm)
        return .init(viewController: vc, transitionPublisher: vm.transitionPublisher)
    }
}
