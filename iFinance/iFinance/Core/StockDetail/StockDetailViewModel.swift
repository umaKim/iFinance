//
//  StockDetailViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import Foundation
import Combine

enum StockDetailViewModelListener {
    case errror
    case reloadData
}

final class StockDetailViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<StockDetailTransition, Never>()
    
    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
    private let listenerSubject = PassthroughSubject<StockDetailViewModelListener, Never>()
    
    /// Quote
//    private var quote: Quote?
    
    /// Stock symbol
//    private let symbol: String

    /// Company name
//    private let companyName: String
    
    /// Company metrics
    private(set) var metrics: Metrics?

    /// Collection of data
//    private(set) var candleStickData: [CandleStick] = []
//    private(set) var closeCandleStickData: [Double] = []
    
    /// Collection of news stories
    private(set) var stories: [NewsStory] = []
    
//    private var watchlistChartMap: [String: [CandleStick]] = [:]
    
    private(set) var myWatchListModel: MyWatchListModel
    
    init(myWatchListModel: MyWatchListModel) {
        self.myWatchListModel = myWatchListModel
        super.init()
        
        fetchFinancialData()
        fetchNews()
    }
    
    
    
    /// Fetch financial metrics
    private func fetchFinancialData() {
        let group = DispatchGroup()

//        group.enter()
//        APICaller.shared.quote(for: myWatchListModel.symbol) {[weak self] result in
//            defer {
//                group.leave()
//            }
//            switch result{
//
//            case .success(let response):
//                self?.quote = response
//            case .failure(let error):
//                print(error)
//            }
//        }

        // Fetch candle sticks if needed
//        if candleStickData.isEmpty {
            //numbersOfDays.forEach { numberOfDays in
//        group.enter()
//        APICaller.shared.marketData(for: myWatchListModel.symbol) { [weak self] result in
//            defer {
//                group.leave()
//            }
//
//            switch result {
//            case .success(let response):
//
//                self?.closeCandleStickData = response.candleSticks.map({$0.close})
//                //                        self?.candleStickDatas.append(response.candleSticks)
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//            }

      //  }

        // Fetch financial metrics
        group.enter()
        APICaller.shared.financialMetrics(for: myWatchListModel.symbol) { [weak self] result in
            defer {
                group.leave()
            }

            switch result {
            case .success(let response):
                self?.metrics = response.metric
                
            case .failure(let error):
                print(error)
            }
        }

        group.notify(queue: .main) { [weak self] in
//            self?.renderChart()
            self?.listenerSubject.send(.reloadData)
        }
    }
    
    private func fetchNews() {
        APICaller.shared.news(for: .compan(symbol: myWatchListModel.symbol)) { [weak self] result in
            switch result {
            case .success(let stories):
                self?.stories = stories
                self?.listenerSubject.send(.reloadData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
