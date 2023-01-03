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
    case error
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
    
//    /// Company metrics
//    private var metrics: Metrics?
    
//    /// Collection of data
//    private var closeCandleStickData: [Double] = []
    
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
        persistanceService.addToWatchlist(symbol: symbol)
        NotificationCenter.default.post(name: .didAddToWatchList, object: nil)
    }
    
    var shouldShowAddButton: Bool {
        persistanceService.watchlistContains(symbol: symbol)
    }
    
    //MARK: - Private method
    /// Fetch financial metrics
    private func fetchData() {
        let quote = networkService.quote(for: symbol)
        let marketData = networkService.marketData(for: symbol, numberOfDays: 7)
        let financialMetrics = networkService.financialMetrics(for: symbol)
        let news = networkService.news(for: .compan(symbol: symbol))
        
        quote
            .zip(marketData, financialMetrics, news)
            .sink(
                receiveCompletion: self.completionHandler,
                receiveValue: {[weak self] (quote, marketData, metrics, newsStories) in
                    self?.headerData = StockDetailHeaderData(
                        currentPrice: "\(quote.currentPrice ?? 0)",
                        percentChange: "\(quote.percentChange ?? 0)",
                        chartViewModel: StockChartModel(
                            data: marketData.candleSticks.map({$0.close}),
                            showLegend: true,
                            showAxis: true,
                            fillColor: self?.calculateFillColor ?? .systemGray3,
                            isFillColor: true
                        ),
                        metrics: metrics.metric)
                    self?.newsStories = newsStories
                })
            .store(in: &cancellables)
    }
    
    private func completionHandler(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(_):
            self.listenerSubject.send(.error)
            
        case .finished:
            self.listenerSubject.send(.reloadData)
        }
    }
    
    private var calculateFillColor: UIColor {
        guard let percentChange = quote?.percentChange else { return .systemFill }
        return percentChange < 0 ? .systemRed : .systemGreen
    }
}
