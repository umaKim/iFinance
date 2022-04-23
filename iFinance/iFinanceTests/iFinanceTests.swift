//
//  iFinanceTests.swift
//  iFinanceTests
//
//  Created by 김윤석 on 2022/04/23.
//
import Combine
import XCTest
@testable import iFinance

class iFinanceTests: XCTestCase {
    
    var sut: MyListViewModel!
    
    private var cancellables: Set<AnyCancellable>!
    
    private let network = NetworkServiceImpl()
    private let persistance = PersistanceImpl()
    
    override func setUp() {
        super.setUp()
        sut = MyListViewModel(networkService: network,
                              persistanceService: persistance)
        cancellables = []
        
    }
    
    func testViewModel() {
        
        //Arrange
        var isEdittingMode: Bool = false
        
        sut
            .listenerPublisher
            .sink { [weak self] listener in
                switch listener{
                case .edittingMode:
                    isEdittingMode.toggle()
                    
                case .reloadData:
                    XCTAssert(true, "nice")
                }
            }
            .store(in: &cancellables)
        
        //Act
        sut.isEdittingModeSubject.send()
        
        //Assert
        XCTAssert(isEdittingMode)
    }
}

//class Mock: NetworkService {
//    func search(query: String) -> AnyPublisher<SearchResponse, Error> {
//        Just(SearchResponse(count: 3, result: [SearchResult(description: "", displaySymbol: "Stock1", symbol: "s1", type: ""),
//                                               SearchResult(description: "", displaySymbol: "Stock2", symbol: "s2", type: ""),
//                                               SearchResult(description: "", displaySymbol: "Stock3", symbol: "s3", type: "")
//                                              ])).setFailureType(to: Error.self).eraseToAnyPublisher()
//    }
//
//    func news(for type: NewsType) -> AnyPublisher<[NewsStory], Error> {
//        Just([NewsStory(category: <#T##String#>,
//                        datetime: TimeInterval(),
//                        headline: <#T##String#>,
//                        image: <#T##String#>,
//                        related: <#T##String#>,
//                        source: <#T##String#>,
//                        summary: <#T##String#>,
//                        url: <#T##String#>)])
//        .setFailureType(to: Error.self)
//        .eraseToAnyPublisher()
//    }
//
//    func marketData(for symbol: String, numberOfDays: TimeInterval, completion: @escaping (Result<MarketDataResponse, Error>) -> Void) {
//
//    }
//
//    func marketData(for symbol: String, numberOfDays: TimeInterval) -> AnyPublisher<MarketDataResponse, Error> {
//        Just(MarketDataResponse(open: <#T##[Double]?#>,
//                                close: <#T##[Double]?#>,
//                                high: <#T##[Double]?#>,
//                                low: <#T##[Double]?#>,
//                                status: <#T##String?#>,
//                                timestamps: <#T##[TimeInterval]?#>))
//        .setFailureType(to: Error.self)
//        .eraseToAnyPublisher()
//    }
//
//    func financialMetrics(for symbol: String) -> AnyPublisher<FinancialMetricsResponse, Error> {
//        Just(FinancialMetricsResponse(metric:
//                                        Metrics(TenDayAverageTradingVolume: <#T##Float?#>,
//                                                AnnualWeekHigh: <#T##Double?#>,
//                                                AnnualWeekLow: <#T##Double?#>,
//                                                AnnualWeekLowDate: <#T##String?#>,
//                                                AnnualWeekPriceReturnDaily: <#T##Float?#>,
//                                                beta: <#T##Float?#>)))
//        .setFailureType(to: Error.self)
//        .eraseToAnyPublisher()
//    }
//
//    func quote(for symbol: String) -> AnyPublisher<Quote, Error> {
//        Just(Quote(currentPrice: <#T##Double?#>,
//                   changePrice: <#T##Double?#>,
//                   percentChange: <#T##Double?#>,
//                   highPriceOfTheDay: <#T##Double?#>,
//                   lowPriceOfTheDay: <#T##Double?#>,
//                   openPriceOfTheDay: <#T##Double?#>,
//                   previousClosePrice: <#T##Double?#>))
//        .setFailureType(to: Error.self)
//        .eraseToAnyPublisher()
//    }
//
//    func fetchCryptoSymbols(from platform: Platform) -> AnyPublisher<[CryptoSymbol], Error> {
//        Just([CryptoSymbol(description: <#T##String#>,
//                           displaySymbol: <#T##String#>,
//                           symbol: <#T##String#>)])
//        .setFailureType(to: Error.self)
//        .eraseToAnyPublisher()
//    }
//
//    func cryptoMarketData(for symbol: String, numberOfDays: TimeInterval) -> AnyPublisher<MarketDataResponse, Error> {
//        Just(MarketDataResponse(open: [],
//                                close: [],
//                                high: [],
//                                low: [],
//                                status: <#T##String?#>,
//                                timestamps: []))
//        .setFailureType(to: Error.self)
//        .eraseToAnyPublisher()
//    }
//}
