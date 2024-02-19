//
//  NetworkService.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/19.
//

import Combine
import Foundation

/// Type of news
enum NewsType {
    case topStories
    case compan(symbol: String)
    
    /// Title for given type
    var title: String {
        switch self {
        case .topStories:
            return "News"
        case .compan(let symbol):
            return symbol.uppercased()
        }
    }
}

protocol NetworkService {
    func search( query: String) -> AnyPublisher<SearchResponse, Error>
    func news(for type: NewsType) -> AnyPublisher<[NewsStory], Error>
//    func marketData(for symbol: String, numberOfDays: TimeInterval, completion: @escaping (Result<MarketDataResponse, Error>) -> Void)
    func marketData(for symbol: String, numberOfDays: TimeInterval) -> AnyPublisher<MarketDataResponse, Error>
    func financialMetrics(for symbol: String) -> AnyPublisher<FinancialMetricsResponse, Error>
    func quote(for symbol: String) -> AnyPublisher<Quote, Error>
//    func fetchCryptoSymbols(from platform: Platform) -> AnyPublisher<[CryptoSymbol], Error>
//    func cryptoMarketData(for symbol: String, numberOfDays: TimeInterval) ->AnyPublisher<MarketDataResponse, Error>
}

/// Type of news
enum `Type` {
    case topStories
    case compan(symbol: String)
    
    /// Title for given type
    var title: String {
        switch self {
        case .topStories:
            return "News"
        case .compan(let symbol):
            return symbol.uppercased()
        }
    }
}

final class NetworkServiceImpl: NetworkService {
//    func marketData(for symbol: String, numberOfDays: TimeInterval, completion: @escaping (Result<MarketDataResponse, Error>) -> Void) {
//        let today = Date().addingTimeInterval(-(Constants.day))
//        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
//
//        guard let url = url(
//            for: .cryptoCandle,
//            queryParams: [
//                "symbol": symbol,
//                "resolution": "5",
//                "from": "\(Int(prior.timeIntervalSince1970))",
//                "to": "\(Int(today.timeIntervalSince1970))"
//            ]) else { return }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//            }
//
//            if let data = data {
//
//                do {
//                    let result = try JSONDecoder().decode(MarketDataResponse.self, from: data)
//                    completion(.success(result))
//                } catch {
//                    completion(.failure(APIError.noDataReturned))
//                }
//            }
//        }
//        .resume()
//    }
    
    /// Constants
    private struct Constants {
        static let apiKey = "c3ecka2ad3ief4elg710"
        static let sandboxApiKey = "sandbox_c3c6me2ad3iefuuilmsg"
        static let baseUrl = "https://finnhub.io/api/v1/"
        static let day: TimeInterval = 3600 * 24
    }
    
    
    // MARK: - Public
    
    /// Search for a company
    /// - Parameters:
    ///   - query: Query string (symbol or name)
    ///   - completion: Callback for result
    public func search(query: String) -> AnyPublisher<SearchResponse, Error> {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        return request(url: url(for: .search, queryParams: ["q": safeQuery]),
                       expecting: SearchResponse.self)
    }
    
    /// Get news for type
    /// - Parameters:
    ///   - type: Company or top stories
    ///   - completion: Result callback
    public func news(for type: NewsType) -> AnyPublisher<[NewsStory], Error> {
        switch type {
        case .topStories:
            return request(url: url(for: .topStories,
                                    queryParams: ["category": "general"]),
                           expecting: [NewsStory].self)
            
        case .compan(let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.day * 1))
            return request(url: url(for: .companyNews, queryParams: [
                "symbol": symbol,
                "from": DateFormatter.newsDateFormatter.string(from: oneMonthBack),
                "to": DateFormatter.newsDateFormatter.string(from: today)
            ]), expecting: [NewsStory].self)
        }
    }
    
    /// Get market data
    /// - Parameters:
    ///   - symbol: Given symbol
    ///   - numberOfDays: Number of days back from today
    ///   - completion: Result callback
    private var cancellables = Set<AnyCancellable>()
    
    public func marketData(for symbol: String, numberOfDays: TimeInterval) -> AnyPublisher<MarketDataResponse, Error> {
        let today = Date().addingTimeInterval(-(Constants.day))
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        return request(url:
                        url(
                            for: .marketData,
                            queryParams: [
                                "symbol": symbol,
                                "resolution": "5",
                                "from": "\(Int(prior.timeIntervalSince1970))",
                                "to": "\(Int(today.timeIntervalSince1970))"
                            ]
                        ),
                       expecting: MarketDataResponse.self
        )
    }
    
    /// Get financial metrics
    /// - Parameters:
    ///   - symbol: Symbol of company
    ///   - completion: Result callback
    public func financialMetrics(for symbol: String) -> AnyPublisher<FinancialMetricsResponse, Error> {
        request(url: url(for: .financials,
                         queryParams: ["symbol": symbol, "metric": "all"]),
                expecting: FinancialMetricsResponse.self)
    }
    
    public func quote(for symbol: String) -> AnyPublisher<Quote, Error> {
        request(url: url(for: .quote, queryParams: ["symbol": symbol]), expecting: Quote.self)
    }
    
//    public func fetchCryptoSymbols(from platform: Platform) -> AnyPublisher<[CryptoSymbol], Error> {
//        request(url: url(for: .cryptoSymbol, queryParams: ["exchange": platform.rawValue]), expecting: [CryptoSymbol].self)
//    }
    
//    public func cryptoMarketData(for symbol: String, numberOfDays: TimeInterval) -> AnyPublisher<MarketDataResponse, Error> {
//        let today = Date().addingTimeInterval(-(Constants.day))
//        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
//
//        return request(url: url(for: .cryptoCandle, queryParams: [
//            "symbol": symbol,
//            "resolution": "5",
//            "from": "\(Int(prior.timeIntervalSince1970))",
//            "to": "\(Int(today.timeIntervalSince1970))"
//        ]), expecting: MarketDataResponse.self)
//    }
    
    // MARK: - Private
    
    /// API Endpoints
    private enum Endpoint: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
        case financials = "stock/metric"
        case quote = "quote"
        
        case cryptoSymbol = "crypto/symbol"
        case cryptoCandle = "crypto/candle"
    }
    
    /// API Errors
    private enum APIError: Error {
        case noDataReturned
        case invalidUrl
    }
    
    /// Try to create url for endpoint
    /// - Parameters:
    ///   - endpoint: Endpoint to create for
    ///   - queryParams: Additional query arguments
    /// - Returns: Optional URL
    private func url(for endpoint: Endpoint, queryParams: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue
        
        var queryItems = [URLQueryItem]()
        // Add any parameters
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        
        // Add token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        // Convert queri items to suffix string
        urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")

        return URL(string: urlString)
    }
    
    /// Perform api call
    /// - Parameters:
    ///   - url: URL to hit
    ///   - expecting: Type we expect to decode data to
    ///   - completion: Result callback
    private func request<T: Codable>(url: URL?, expecting: T.Type) -> AnyPublisher<T, Error> {
        Future { promise in
            guard let url = url else { return
                promise(.failure( APIError.invalidUrl))}
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.failure(APIError.noDataReturned))
                    }
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(expecting, from: data)
                    promise(.success(result))
                }
                catch {
                    promise(.failure(error))
                }
            }
            .resume()
        }
        .eraseToAnyPublisher()
    }
}
