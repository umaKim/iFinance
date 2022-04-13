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
    case didTap
}

final class MyListViewModel {
    private(set) lazy var listenerPublisher = listernSubject.eraseToAnyPublisher()
    private let listernSubject = PassthroughSubject<MyListViewModelListener, Never>()
    
    //MARK: - Model
    
    private var watchlistChartMap: [String: [CandleStick]] = [:]
    private var watchlistQuoteMap: [String: Quote] = [:]
    
    //MARK: - ViewModel
    
    private(set) var myWatchStocks: [MyWatchListModel] = []
    
    /// Delegate
//    weak var delegate: MyListViewModelDelegate?
    
    /// Observer for watch list updates
    private var observer: NSObjectProtocol?
    
    
    //Fetch from network for stock data
    init() {
        fetchWatchlistData()
    }
    
    /// Fetch watch list models
    func fetchWatchlistData() {
        let symbols = PersistenceManager.shared.watchlist

        createPlaceholderForLoadingMyWatchStock()

        let group = DispatchGroup()

//        for symbol in symbols where watchlistQuoteMap[symbol] == nil {

        symbols.forEach { symbol in

            group.enter()
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }

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
                defer {
                    group.leave()
                }

                switch result {
                case .success(let quote):
                    self?.watchlistQuoteMap[symbol] = quote
                case .failure(let error):
                    print(error)
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.createMyWatchStocks()
//            self?.tableView.reloadData()
//            self?.delegate?.updateTableView()
            self?.listernSubject.send(.reloadData)
        }
    }
    
    /// Creates view models from models
    private func createMyWatchStocks() {
        var viewModels = [MyWatchListModel]()
        
        for (symbol, candleSticks) in watchlistChartMap {
            let changePercentage = watchlistQuoteMap[symbol]?.percentChange
            
            viewModels.append(
                .init(
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
                )
            )
        }
        
        self.myWatchStocks = viewModels.sorted(by: { $0.symbol < $1.symbol })
    }
    
    private func createPlaceholderForLoadingMyWatchStock() {
        let symbols = PersistenceManager.shared.watchlist
        symbols.forEach { _ in
            myWatchStocks.append(
                .init(symbol: "Loading", companyName: "...",
                      price: "Loding", changeColor: .darkGray, changePercentage: "...",
                      chartViewModel: .init( data: [], showLegend: false, showAxis: false, fillColor: .clear, isFillColor: false)
                     )
            )
        }
//        self.myWatchStocks = myWatchStocks.sorted(by: { $0.symbol < $1.symbol })
//        self.delegate?.updateTableView()
        self.listernSubject.send(.reloadData)
    }
    
    /// Gets latest closing price
    /// - Parameter data: Collection of data
    /// - Returns: String
    private func getLatestClosingPrice(from data: [CandleStick]) -> String {
        guard let closingPrice = data.first?.close else { return ""}
        return .formatted(number: closingPrice)
    }
    
    func didTap() {
        listernSubject.send(.didTap)
    }
}
