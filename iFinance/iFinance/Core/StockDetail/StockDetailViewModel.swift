//
//  StockDetailViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import Foundation
import Combine
import UIKit

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
    private var quote: Quote?
    /// Company metrics
    private var metrics: Metrics?
    /// Collection of data
    private var closeCandleStickData: [Double] = []
    
    /// Collection of news stories
    private(set) var newsStories: [NewsStory] = []
    
    //    private var watchlistChartMap: [String: [CandleStick]] = [:]
    
    //    private(set) var myWatchListModel: MyWatchListModel
    private(set) var symbol: String
    private(set) var headerData: StockDetailHeaderData?
    
    init(symbol: String) {
        self.symbol = symbol
        super.init()
        
        fetchData()
    }
    
    func didTapNews(at indexPath: IndexPath) {
        guard let url = URL(string: newsStories[indexPath.row].url) else { return }
        transitionSubject.send(.didTapNews(url))
    }
    
    func didTapAddToMyWatchList() {
        PersistenceManager.shared.addToWatchlist(symbol: symbol)
        NotificationCenter.default.post(name: .didAddToWatchList, object: nil)
    }
    
    /// Fetch financial metrics
    private func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        APICaller.shared.quote(for: symbol) {[weak self] result in
            defer {
                group.leave()
            }
            switch result{
                
            case .success(let response):
                self?.quote = response
                
            case .failure(let error):
                print(error)
                self?.quote = .init(currentPrice: 0, changePrice: 0, percentChange: 0, highPriceOfTheDay: 0, lowPriceOfTheDay: 0, openPriceOfTheDay: 0, previousClosePrice: 0)
            }
        }
        
        // Fetch candle sticks if needed
        group.enter()
        APICaller.shared.marketData(for: symbol) { [weak self] result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let response):
                self?.closeCandleStickData = response.candleSticks.map({$0.close})
            case .failure(let error):
                print(error)
                self?.closeCandleStickData = []
            }
        }
        
        // Fetch financial metrics
        group.enter()
        APICaller.shared.financialMetrics(for: symbol) { [weak self] result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let response):
                self?.metrics = response.metric
                
            case .failure(let error):
                print(error.localizedDescription)
                self?.metrics = .init(TenDayAverageTradingVolume: 0, AnnualWeekHigh: 0, AnnualWeekLow: 0, AnnualWeekLowDate: "", AnnualWeekPriceReturnDaily: 0, beta: 0)
            }
        }
        
        group.enter()
        APICaller.shared.news(for: .compan(symbol: symbol)) { [weak self] result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let stories):
                self?.newsStories = stories
            case .failure(let error):
                print(error.localizedDescription)
                self?.newsStories = []
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self,
                  let metrics = self.metrics else {
                return
            }
            
            self.headerData = StockDetailHeaderData(
                currentPrice: "\(self.quote?.currentPrice ?? 0)",
                percentChange: "\(self.quote?.percentChange ?? 0)",
                chartViewModel: StockChartModel(data: self.closeCandleStickData ,
                                                showLegend: true,
                                                showAxis: true,
                                                fillColor: self.calculateFillColor,
                                                isFillColor: true),
                metrics: metrics)
            
            self.listenerSubject.send(.reloadData)
        }
    }
    
    private var calculateFillColor: UIColor {
        guard let percentChange = quote?.percentChange else {return .systemFill}
        return percentChange < 0 ? .systemRed : .systemGreen
    }
}
