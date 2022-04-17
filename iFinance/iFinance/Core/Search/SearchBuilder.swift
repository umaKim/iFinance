//
//  SearchBuilder.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/17.
//

import UIKit.UIViewController

enum SearchTransition: Transition {
    case didSelect(SearchResult)
}

final class SearchBuilder {
    class func build() -> Module<SearchTransition, UIViewController> {
        let vm = SearchViewModel()
        let vc = SearchViewController(viewModel: vm)
        return .init(viewController: vc, transitionPublisher: vm.transitionPublisher)
    }
}
