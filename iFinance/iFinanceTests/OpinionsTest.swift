//
//  OpinionsTest.swift
//  iFinanceTests
//
//  Created by 김윤석 on 2022/04/24.
//

import Combine
import XCTest
@testable import iFinance

class OpinionsTest: XCTestCase {
    
    private var viewModel: OpinionsViewModel!
    private var viewController: OpinionsViewController!
    private var view: OpinionsView!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        self.viewModel = OpinionsViewModel(firebaseNetwork: FirebaseRealTimeMock())
        self.viewController = OpinionsViewController(viewModel: viewModel)
        self.view = OpinionsView(frame: .zero)
        self.cancellables = .init()
        super.setUp()
        
    }
    
    func testOpinions() {
        //Arrange
        viewModel
            .listenerPublisher
            .sink { listen in
                switch listen {
                case .reloadData:
                    break
                    
                case .didTap:
                    break
                }
            }
            .store(in: &cancellables)
        
        //Act
        viewController.loadView()
        viewController.tableView(view.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        //Assert
        XCTAssert(viewModel.opinions.count == 1)
        XCTAssertNotNil(viewController.tableView(view.tableView, cellForRowAt: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(viewController.tableView(view.tableView, numberOfRowsInSection: 0),
                       viewModel.opinions.count)
    }
}
