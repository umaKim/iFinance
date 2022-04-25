//
//  PersistanceMock.swift
//  iFinanceTests
//
//  Created by 김윤석 on 2022/04/25.
//

import Foundation
@testable import iFinance

final class PersistanceMock: PersistanceService {
    var watchlist: [String] = [
        "UMA",
        "TESLA",
        "GOOG",
        "GOOGL"
    ]
    
    func watchlistContains(symbol: String) -> Bool {
        watchlist.contains(symbol)
    }
    
    func addToWatchlist(symbol: String) {
        watchlist.append(symbol)
    }
    
    func removeFromWatchlist(symbol: String) {
        watchlist.removeAll { $0 == symbol }
    }
}
