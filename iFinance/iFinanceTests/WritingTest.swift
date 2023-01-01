//
//  WritingTest.swift
//  iFinanceTests
//
//  Created by 김윤석 on 2022/04/26.
//

import Combine
import XCTest
@testable import iFinance

class WritingTest: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        self.cancellables = .init()
        super.setUp()
    }
    
    func testViewModel() {
        let module = WritingBuilder.build(
            container: AppContainerMock(),
            dependncy: WritingViewModelDependencyImp(symbol: "UMA")
//            symbol: "UMA"
        )
        module
            .transitionPublisher
            .sink { trans in
                switch trans {
                case .dismiss:
                    break
                    
                case .done:
                    break
                }
            }
            .store(in: &cancellables)
        
        module.viewController.loadViewIfNeeded()
        
        let coord = WritingCoordinator(
            navigationController: UINavigationController(),
            conainter: AppContainerMock(),
            dependency: WritingViewModelDependencyImp(symbol: "UMA")
//            symbol: "UMA"
        )
        coord.start()
    }
}
