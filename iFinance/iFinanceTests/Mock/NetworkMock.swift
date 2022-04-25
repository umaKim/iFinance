//
//  NetworkMock.swift
//  iFinanceTests
//
//  Created by 김윤석 on 2022/04/24.
//

import Foundation
import Combine
@testable import iFinance

final class NetworkMock: NetworkService {
    func search(query: String) -> AnyPublisher<SearchResponse, Error> {
        let searchResults = [
            SearchResult(description: "", displaySymbol: "", symbol: "", type: ""),
            SearchResult(description: "", displaySymbol: "", symbol: "", type: "")
        ]
        return Just(SearchResponse(count: searchResults.count, result: searchResults))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func news(for type: NewsType) -> AnyPublisher<[NewsStory], Error> {
        let news:[NewsStory] = [
            NewsStory(category: "umaCategory",
                      datetime: 1000,
                      headline: "umaHeadline",
                      image: "umaImage",
                      related: "umaRelated",
                      source: "umaSource",
                      summary: "umaSummary",
                      url: "umaURL")
        ]
        
        return Just(news)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func marketData(for symbol: String, numberOfDays: TimeInterval) -> AnyPublisher<MarketDataResponse, Error> {
        let marketData = MarketDataResponse(open: [],
                                            close: [],
                                            high: [],
                                            low: [],
                                            status: "",
                                            timestamps: [])
        
        return Just(marketData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func financialMetrics(for symbol: String) -> AnyPublisher<FinancialMetricsResponse, Error> {
        let metrics = Metrics(TenDayAverageTradingVolume: 10,
                             AnnualWeekHigh: 10,
                             AnnualWeekLow: 10,
                             AnnualWeekLowDate: "",
                             AnnualWeekPriceReturnDaily: 10,
                             beta: 10)
        
        let financialMetrics = FinancialMetricsResponse(metric: metrics)
        return Just(financialMetrics)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func quote(for symbol: String) -> AnyPublisher<Quote, Error> {
        let quote = Quote(currentPrice: 20,
                          changePrice: 20,
                          percentChange: 20,
                          highPriceOfTheDay: 20,
                          lowPriceOfTheDay: 20,
                          openPriceOfTheDay: 20,
                          previousClosePrice: 20)
        
        return Just(quote)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
