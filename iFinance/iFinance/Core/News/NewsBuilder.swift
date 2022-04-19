//
//  NewsBuilder.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/19.
//

import UIKit.UIViewController

enum NewsViewTransition: Transition {
    case didTapNews(NewsStory)
}

final class NewsBuilder {
    class func build(container: AppContainer, type: NewsType) -> Module<NewsViewTransition, UIViewController> {
        let vm = NewsViewModel(networkService: container.networkService,
                               type: type)
        let vc = NewsViewController(viewModel: vm)
        return .init(viewController: vc, transitionPublisher: vm.transitionPublisher)
    }
}
