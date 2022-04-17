//
//  MainHomeBuilder.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import UIKit.UIViewController

final class MainHomeBuilder {
    class func build() -> Module<MainHomeTransition, UIViewController> {
        let viewModel = MainViewModel(myListViewModel: MyListViewModel(),
                                      opinionsViewModel: OpinionsViewModel())
        let vc = MainViewController(viewModel: viewModel)
        return .init(viewController: vc, transitionPublisher: viewModel.transitionPublisher)
    }
}
