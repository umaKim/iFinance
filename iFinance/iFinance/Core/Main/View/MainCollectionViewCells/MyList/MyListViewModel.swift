//
//  MyListViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/13.
//

import Combine
import UIKit

enum MyListViewModelListener {
    case reloadData
    case edittingMode
}

final class MyListViewModel: BaseViewModel {
    
    //MARK: - Combine
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<MyListViewTransition, Never>()
    
    private(set) lazy var listenerPublisher = listernSubject.eraseToAnyPublisher()
    private let listernSubject = PassthroughSubject<MyListViewModelListener, Never>()
    
    private(set) lazy var actionNotifier = PassthroughSubject<MyListActionNotification, Never>()
    
    //MARK: - Model
    private var watchlistChartMap: [String: [CandleStick]] = [:]
    private var watchlistQuoteMap: [String: Quote] = [:]
    private(set) var myWatchStocks: [MyWatchListModel] = []
    
    private let networkService: NetworkService
    private let persistanceService: PersistanceService
    
    //MARK: - Init
    init(
        networkService: NetworkService,
        persistanceService: PersistanceService
    ) {
        self.networkService = networkService
        self.persistanceService = persistanceService
        super.init()
        
        fetchWatchlistData()
        bind()
        setUpObserver()
    }
    
    enum Section: CaseIterable {
        case main
    }
    
    /// Sets up observer for watch list updates
    private func setUpObserver() {
        NotificationCenter
            .default
            .publisher(for: .didAddToWatchList)
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.myWatchStocks.removeAll()
                self.persistanceService.watchlist.forEach({self.fetch(symbol: $0)})
            }
            .store(in: &cancellables)
    }
    
    private func bind() {
        actionNotifier
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .isEdittingButtonDidTap:
                    self.listernSubject.send(.edittingMode)
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetch(symbol: String) {
        let marketData = networkService.marketData(for: symbol, numberOfDays: 7)
        let quote = networkService.quote(for: symbol)
        
        quote
            .zip(marketData)
            .receive(on: RunLoop.main)
            .collect()
            .sink {[weak self] completion in
                guard let self = self else {return }
                switch completion {
                case .failure(let error):
                    print("\(error)")
                case .finished:
                    self.myWatchStocks.removeAll()
                    self.createMyWatchStocks()
                    self.listernSubject.send(.reloadData)
                }
            } receiveValue: {[weak self] collect in
                guard let self = self else {return }
                collect.forEach { (quote, marketDataResponse) in
                    self.watchlistChartMap[symbol] = marketDataResponse.candleSticks
                    self.watchlistQuoteMap[symbol] = quote
                }
            }.store(in: &cancellables)
    }
    
    /// Fetch watch list models
    private func fetchWatchlistData() {
        createPlaceholderForLoadingMyWatchStock()
        self.persistanceService.watchlist.forEach({ self.fetch(symbol: $0) })
    }
    
    /// Creates view models from models
    private func createMyWatchStocks() {
        for (symbol, candleSticks) in watchlistChartMap {
            let changePercentage = watchlistQuoteMap[symbol]?.percentChange
            
            myWatchStocks.append(.init(
                symbol: symbol,
                companyName: UserDefaults.standard.string(forKey: symbol) ?? "Company",
                price: getLatestClosingPrice(from: candleSticks),
                changeColor: changePercentage ?? 0.0 < 0 ? .systemRed : .systemGreen,
                changePercentage: .percentage(from: changePercentage ?? 0.0),
                chartViewModel: .init(
                    data: candleSticks.reversed().map { $0.close },
                    showLegend: false,
                    showAxis: false,
                    fillColor: changePercentage ?? 0.0 < 0 ? .systemRed : .systemGreen,
                    isFillColor: false
                )
            ))
        }
        
        self.myWatchStocks.sort(by: { $0.symbol < $1.symbol })
    }
    
    private func createPlaceholderForLoadingMyWatchStock() {
        let symbols = persistanceService.watchlist
        
        symbols.forEach { _ in
            myWatchStocks.append (
                .init(
                    symbol: "Loading",
                    companyName: "...",
                    price: "Loding",
                    changeColor: .darkGray,
                    changePercentage: "...",
                    chartViewModel: .init(
                        data: [],
                        showLegend: false,
                        showAxis: false,
                        fillColor: .clear,
                        isFillColor: false
                    )
                )
            )
        }
        self.listernSubject.send(.reloadData)
    }
    
    /// Gets latest closing price
    /// - Parameter data: Collection of data
    /// - Returns: String
    private func getLatestClosingPrice(from data: [CandleStick]) -> String {
        guard let closingPrice = data.first?.close else { return "" }
        return .formatted(number: closingPrice)
    }
    
    func didTap(myWatchStock: MyWatchListModel) {
        transitionSubject.send(.didTap(myWatchStock))
    }
    
    func removeItem(at indexPath: IndexPath) {
        persistanceService.removeFromWatchlist(symbol: myWatchStocks[indexPath.row].symbol)
        myWatchStocks.remove(at: indexPath.row)
    }
}
