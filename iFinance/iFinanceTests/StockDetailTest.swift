//
//  StockDetailTest.swift
//  iFinanceTests
//
//  Created by 김윤석 on 2022/04/25.
//

import Combine
//import Foundation
import XCTest
@testable import iFinance

class StockDetailTest: XCTestCase {
    
    private var viewModel: StockDetailViewModel!
    private var viewController: StockDetailViewController!
    private var view: StockDetailView!
    private var headerView: StockDetailHeaderView!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        self.viewModel = StockDetailViewModel(networkService: NetworkMock(),
                                              persistanceService: PersistanceMock(),
                                              symbol: "UMA")
        self.viewController = StockDetailViewController(viewModel: viewModel)
        self.view = StockDetailView()
        self.headerView = StockDetailHeaderView()
        self.cancellables = .init()
        super.setUp()
        
    }
    
    func testViewModel() {
        //Arrange
        var didTapNews: Bool = false
        
        let symbol = viewModel.symbol
        viewModel
            .transitionPublisher
            .sink { trans in
                switch trans {
                case .didTapNews(let url):
                    didTapNews = true
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .listenerPublisher
            .sink { listen in
                switch listen {
                case .reloadData:
                    break
                    
                case .error:
                    break
                }
            }
            .store(in: &cancellables)
        
        //Act
        viewModel.didTapNews(at: IndexPath(row: 0, section: 0))
        viewModel.didTapAddToMyWatchList()
        
        //Assert
        XCTAssertEqual(symbol, "UMA")
        XCTAssertTrue(didTapNews)
        XCTAssertEqual(viewModel.newsStories.count, 1)
    }
    
    func testViewController() {
        //Arrange
        viewController.loadView()
        viewController.tableView(view.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        //Act
        
        //Assert
        XCTAssertEqual( viewController.tableView(view.tableView, numberOfRowsInSection: 0),
                        viewModel.newsStories.count)
        XCTAssertNotNil(viewController.tableView(view.tableView, cellForRowAt: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(viewController.tableView(view.tableView, heightForRowAt: IndexPath(row: 0, section: 0)),
                       NewsStoryTableViewCell.preferredHeight)
        XCTAssertEqual(viewController.tableView(view.tableView, heightForHeaderInSection: 0), NewsHeaderView.preferredHeight)
        XCTAssertNotNil(viewController.tableView(view.tableView, viewForHeaderInSection: 0))
    }
}
