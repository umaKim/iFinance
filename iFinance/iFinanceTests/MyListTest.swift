//
//  MyListTest.swift
//  iFinanceTests
//
//  Created by 김윤석 on 2022/04/24.
//

import Combine
import XCTest
@testable import iFinance

class MyListTest: XCTestCase {
    
    private var viewModel: MyListViewModel!
    private var viewController: MyListViewController!
    private var view: MyListView!
    
    private var cancellbales: Set<AnyCancellable>!
    
    override func setUp() {
        self.viewModel = MyListViewModel(networkService: NetworkMock(),
                                         persistanceService: PersistanceMock())
        self.viewController = MyListViewController(viewModel: viewModel)
        self.view = MyListView()
        self.cancellbales = .init()
        super.setUp()
    }
    
    func testViewModel() {
        
        var didTapModel: Bool = false
        var edittingMode: Bool = false
        
        viewModel
            .transitionPublisher
            .sink { trans in
                switch trans {
                case .didTap(let model):
                    didTapModel = true
                }
            }.store(in: &cancellbales)
        
        viewModel
            .listenerPublisher
            .sink {[weak self] listen in
                switch listen {
                case .reloadData:
                    break
                case .edittingMode:
                    edittingMode = true
                }
            }
            .store(in: &cancellbales)
        
        let model = MyWatchListModel(symbol: "UMA",
                                     companyName: "Company",
                                     price: "",
                                     changeColor: .clear,
                                     changePercentage: "",
                                     chartViewModel: StockChartModel(data: [], showLegend: true, showAxis: true, fillColor: .clear, isFillColor: true))
        
        //Act
        viewModel.didTap(myWatchStock: model)
        viewModel.removeItem(at: IndexPath(row: 0, section: 0))
        viewModel.actionNotifier.send(.isEdittingButtonDidTap)
        
        //Assert
        XCTAssertTrue(didTapModel)
        XCTAssertEqual(viewModel.myWatchStocks.count,
                       PersistanceMock().watchlist.count - 1)
        XCTAssertTrue(edittingMode)
    }
    
    func testViewController() {
        viewController.loadView()
        XCTAssertEqual(viewController.tableView(view.tableView, heightForRowAt: IndexPath(row: 0, section: 0)),
                       WatchListTableViewCell.preferredHeight)
        XCTAssertNotNil(viewController.tableView(view.tableView, didSelectRowAt: IndexPath(row: 0, section: 0)))
    }
}
