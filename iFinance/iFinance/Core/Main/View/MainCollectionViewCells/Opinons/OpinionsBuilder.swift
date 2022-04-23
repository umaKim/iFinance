//
//  OpinionsBuilder.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/24.
//

import Foundation
import UIKit

final class OpinionsBuilder {
    class func build() -> Module<OpinionsViewTransition, UIViewController> {
        let vm = OpinionsViewModel()
        let vc = OpinionsViewController(viewModel: vm)
        return .init(viewController: vc, transitionPublisher: vm.transitionPublisher)
    }
}
