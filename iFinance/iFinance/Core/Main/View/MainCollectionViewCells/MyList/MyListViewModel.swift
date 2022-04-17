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
    case didTap(MyWatchListModel)
    case edittingMode
}

final class MyListViewModel: BaseViewModel {
    private(set) lazy var listenerPublisher = listernSubject.eraseToAnyPublisher()
    private let listernSubject = PassthroughSubject<MyListViewModelListener, Never>()
    
    //MARK: - Model
    
    private var watchlistChartMap: [String: [CandleStick]] = [:]
    private var watchlistQuoteMap: [String: Quote] = [:]
    
    //MARK: - ViewModel
    
    private(set) var myWatchStocks: [MyWatchListModel] = []
    
    //    private(set) var isEdittingMode: Bool
    lazy var isEdittingModeSubject = PassthroughSubject<Void, Never>()
    
    private var isEdittingMode: Bool = false
    
    ///Fetch from network for stock data
    override init() {
        super.init()
        fetchWatchlistData()
        bind()
        setUpObserver()
    }
    
    /// Observer for watch list updates
    private var observer: NSObjectProtocol?
    
    /// Sets up observer for watch list updates
    private func setUpObserver() {
        NotificationCenter.default.publisher(for: .didAddToWatchList)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.myWatchStocks.removeAll()
                self?.fetchWatchlistData()
            }
            .store(in: &cancellables)
    }
    
    private func bind() {
        isEdittingModeSubject
            .sink {[weak self] _ in
                guard let self = self else {return }
                self.isEdittingMode.toggle()
                self.listernSubject.send(.edittingMode)
            }
            .store(in: &cancellables)
    }
    
    /// Fetch watch list models
    func fetchWatchlistData() {
        let symbols = PersistenceManager.shared.watchlist
        
        createPlaceholderForLoadingMyWatchStock()
        
        let group = DispatchGroup()
        
        symbols.forEach { symbol in
            
            group.enter()
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                defer { group.leave() }
                
                switch result {
                case .success(let data):
                    let candleSticks = data.candleSticks
                    self?.watchlistChartMap[symbol] = candleSticks
                case .failure(let error):
                    print(error)
                }
            }
            
            group.enter()
            APICaller.shared.quote(for: symbol) { [weak self] result in
                defer { group.leave() }
                
                switch result {
                case .success(let quote):
                    self?.watchlistQuoteMap[symbol] = quote
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.myWatchStocks.removeAll()
            self?.createMyWatchStocks()
            self?.listernSubject.send(.reloadData)
        }
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
        let symbols = PersistenceManager.shared.watchlist
        symbols.forEach { _ in
            myWatchStocks.append (
                .init(symbol: "Loading", companyName: "...",
                      price: "Loding", changeColor: .darkGray, changePercentage: "...",
                      chartViewModel: .init( data: [],
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
        guard let closingPrice = data.first?.close else { return ""}
        return .formatted(number: closingPrice)
    }
    
    func didTap(myWatchStocks: MyWatchListModel) {
        listernSubject.send(.didTap(myWatchStocks))
    }
}
