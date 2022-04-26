//
//  MainTest.swift
//  iFinanceTests
//
//  Created by 김윤석 on 2022/04/24.
//
import Combine
import XCTest
@testable import iFinance

class MainTest: XCTestCase {
    private var viewModel: MainViewModel!
    private var viewController: MainViewController!
    private var view: MainView!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        self.viewModel = MainViewModel(myListViewModel: MyListViewModel(networkService: NetworkMock(),
                                                                        persistanceService: PersistanceMock()),
                                       opinionsViewModel: OpinionsViewModel(firebaseNetwork: FirebaseRealTimeMock()))
        self.viewController = MainViewController(viewModel: viewModel)
        self.view = MainView()
        self.cancellables = .init()
        super.setUp()
    }
    
    func testCoordinator() {
        let coordinator = MainHomeCoordinator(navigationController: UINavigationController(),
                                              conainter: AppContainerMock())
        coordinator.start()
    }
    
    func testViewController() {
        
        viewController.viewDidLoad()
        viewController.viewDidLayoutSubviews()
        view.menuTabBar.selectItem(at: 0)
        
        XCTAssertNotNil(viewController.collectionView(view.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)))
        XCTAssertTrue( viewController.collectionView(view.collectionView, numberOfItemsInSection: 0) == 2)
        XCTAssertEqual(viewController.collectionView(view.collectionView,
                                                     layout: view.collectionView.collectionViewLayout,
                                                     sizeForItemAt: IndexPath(row: 0, section: 0)),
                       CGSize(width: view.frame.width, height: view.collectionView.frame.height))
    }
    
    func testMain_MyListViewModel_transitionPublisher() {
        //Arrange
        var receivedStockName: String = ""
        var opinionDetailDidTap: Bool = false
        var searchViewDidTap: Bool = false
        var writingOpinionButtonDidTap: Bool = false
        var newsDidTap: Bool = false
        
        viewModel
            .transitionPublisher
            .sink {transition in
                switch transition {
                case .searchView:
                    searchViewDidTap = true
                    
                case .opinionWritingView:
                    writingOpinionButtonDidTap = true
                    
                case .stockDetail(let stockName):
                    receivedStockName = stockName
                    
                case .opinionDetail:
                    opinionDetailDidTap = true
                    
                case .newsDetail(let url):
                    newsDidTap = (url == URL(string: "newsUrl"))
                }
            }
            .store(in: &cancellables)
        
        //Act
        viewModel.searchButtonDidTap()
        viewModel.writingOpinionButtonDidTap()
        viewModel.stockDidTap(MyWatchListModel(symbol: "UMA",
                                               companyName: "Company",
                                               price: "",
                                               changeColor: .clear,
                                               changePercentage: "",
                                               chartViewModel: StockChartModel(data: [],
                                                                               showLegend: true,
                                                                               showAxis: true,
                                                                               fillColor: .clear,
                                                                               isFillColor: true)))
        viewModel.opinionDidTap()
        viewModel.newsDidTap(news: NewsStory(category: "",
                                             datetime: 100,
                                             headline: "",
                                             image: "",
                                             related: "",
                                             source: "",
                                             summary: "",
                                             url: "newsUrl"))
        
        //Assert
        XCTAssert(searchViewDidTap)
        XCTAssert(writingOpinionButtonDidTap)
        XCTAssert(receivedStockName == "UMA")
        XCTAssert(opinionDetailDidTap)
        XCTAssert(newsDidTap)
    }
    
    func testMain_MyListViewModel_actionNotifier() {
        //Arrange
        var isEdittingButtonDidTap: Bool = false
        
        viewModel.myListViewModel
            .actionNotifier
            .sink { noti in
                switch noti {
                case .isEdittingButtonDidTap:
                    isEdittingButtonDidTap = true
                }
            }
            .store(in: &cancellables)
        
        //Act
        viewModel.edittingDidTap()
        
        //Assert
        XCTAssert(isEdittingButtonDidTap)
    }
}
