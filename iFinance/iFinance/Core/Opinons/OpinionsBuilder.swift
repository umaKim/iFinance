//
//  OpinionsBuilder.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/24.
//

import Foundation
import UIKit

final class OpinionsBuilder {
    class func build(container: AppContainer) -> Module<OpinionsViewTransition, UIViewController> {
        let vm = OpinionsViewModel(firebaseNetwork: container.firebaseNetworkService)
        let vc = OpinionsViewController(viewModel: vm)
        return .init(viewController: vc, transitionPublisher: vm.transitionPublisher)
    }
}
