//
//  StockDetailViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import Foundation
import Combine
import UIKit.UIColor

enum StockDetailViewModelListener {
    case errror
    case reloadData
}

final class StockDetailViewModel: BaseViewModel {
    
    //MARK: - Combine
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<StockDetailTransition, Never>()
    
    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
    private let listenerSubject = PassthroughSubject<StockDetailViewModelListener, Never>()
    
    //MARK: - Model
    /// Quote
    private var quote: Quote?
    
    /// Company metrics
    private var metrics: Metrics?
    
    /// Collection of data
    private var closeCandleStickData: [Double] = []
    
    /// Collection of news stories
    private(set) var newsStories: [NewsStory] = []
    
    private(set) var symbol: String
    private(set) var headerData: StockDetailHeaderData?
    
    private let networkService: NetworkService
    private let persistanceService: PersistanceService
    
    //MARK: - Init
    init(
        networkService: NetworkService,
        persistanceService: PersistanceService,
        symbol: String
    ) {
        self.networkService = networkService
        self.persistanceService = persistanceService
        self.symbol = symbol
        super.init()
        
        fetchData()
    }
    
    func didTapNews(at indexPath: IndexPath) {
        guard let url = URL(string: newsStories[indexPath.row].url) else { return }
        transitionSubject.send(.didTapNews(url))
    }
    
    func didTapAddToMyWatchList() {
        //        PersistenceManager.shared.addToWatchlist(symbol: symbol)
        persistanceService.addToWatchlist(symbol: symbol)
        NotificationCenter.default.post(name: .didAddToWatchList, object: nil)
    }
    
    var shouldShowAddButton: Bool {
        persistanceService.watchlistContains(symbol: symbol)
    }
    
    /// Fetch financial metrics
    private func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        networkService.quote(for: symbol) {[weak self] result in
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
        networkService.marketData(for: symbol, numberOfDays: 7) { [weak self] result in
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
        networkService.financialMetrics(for: symbol) { [weak self] result in
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
        networkService.news(for: .compan(symbol: symbol)) { [weak self] result in
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
        guard let percentChange = quote?.percentChange else { return .systemFill }
        return percentChange < 0 ? .systemRed : .systemGreen
    }
}
