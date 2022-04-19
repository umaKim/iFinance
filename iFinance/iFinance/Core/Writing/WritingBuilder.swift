//
//  WritingBuilder.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/18.
//

import Combine
import UIKit

enum WritingTransition: Transition {
    case done, dismiss
}

final class WritingBuilder {
    class func build(symbol: String) -> Module<WritingTransition, UIViewController> {
        let vm = WritingViewModel(symbol: symbol)
        let vc = WritingViewController(viewModel: vm)
        return .init(viewController: vc, transitionPublisher: vm.transitionPublisher)
    }
}
