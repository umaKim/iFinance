//
//  NetworkService.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/19.
//

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

enum Platform: String {
    case binance// = "binance"
    case coinbase// = "coinbase"
}

protocol NetworkService {
    func search( query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void)
    func news( for type: NewsType, completion: @escaping (Result<[NewsStory], Error>) -> Void)
    func marketData(for symbol: String, numberOfDays: TimeInterval, completion: @escaping (Result<MarketDataResponse, Error>) -> Void)
    func financialMetrics(for symbol: String, completion: @escaping (Result<FinancialMetricsResponse, Error>) -> Void)
    func quote(for symbol: String, completion: @escaping (Result<Quote, Error>)-> Void)
    func fetchCryptoSymbols(from platform: Platform, completion: @escaping (Result<[CryptoSymbol], Error>)-> Void)
    func cryptoMarketData(for symbol: String, numberOfDays: TimeInterval, completion: @escaping (Result<MarketDataResponse, Error>) -> Void)
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
    /// Constants
    private struct Constants {
        static let apiKey = "c3c6me2ad3iefuuilms0"
        static let sandboxApiKey = "sandbox_c3c6me2ad3iefuuilmsg"
        static let baseUrl = "https://finnhub.io/api/v1/"
        static let day: TimeInterval = 3600 * 24
    }

   
    // MARK: - Public

    /// Search for a company
    /// - Parameters:
    ///   - query: Query string (symbol or name)
    ///   - completion: Callback for result
    public func search( query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) else {
            return
        }
        
        request(url: url(for: .search, queryParams: ["q": safeQuery]), expecting: SearchResponse.self, completion: completion)
    }

    /// Get news for type
    /// - Parameters:
    ///   - type: Company or top stories
    ///   - completion: Result callback
    public func news(for type: NewsType, completion: @escaping (Result<[NewsStory], Error>) -> Void) {
        switch type {
        case .topStories:
            request(
                url: url(for: .topStories, queryParams: ["category": "general"]),
                expecting: [NewsStory].self,
                completion: completion
            )
        case .compan(let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.day * 7))
            request(
                url: url(
                    for: .companyNews,
                    queryParams: [
                        "symbol": symbol,
                        "from": DateFormatter.newsDateFormatter.string(from: oneMonthBack),
                        "to": DateFormatter.newsDateFormatter.string(from: today)
                    ]
                ),
                expecting: [NewsStory].self,
                completion: completion
            )
        }
    }

    /// Get market data
    /// - Parameters:
    ///   - symbol: Given symbol
    ///   - numberOfDays: Number of days back from today
    ///   - completion: Result callback
    public func marketData(for symbol: String, numberOfDays: TimeInterval = 7, completion: @escaping (Result<MarketDataResponse, Error>) -> Void) {
        
        let today = Date().addingTimeInterval(-(Constants.day))
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        
        request(
            url: url(
                for: .cryptoCandle,
                queryParams: [
                    "symbol": symbol,
                    "resolution": "5",
                    "from": "\(Int(prior.timeIntervalSince1970))",
                    "to": "\(Int(today.timeIntervalSince1970))"
                ]
            ),
            expecting: MarketDataResponse.self,
            completion: completion
        )
    }

    /// Get financial metrics
    /// - Parameters:
    ///   - symbol: Symbol of company
    ///   - completion: Result callback
    public func financialMetrics(for symbol: String, completion: @escaping (Result<FinancialMetricsResponse, Error>) -> Void) {
        request(
            url: url(for: .financials, queryParams: ["symbol": symbol, "metric": "all"]),
            expecting: FinancialMetricsResponse.self,
            completion: completion
        )
    }
    
    public func quote(for symbol: String, completion: @escaping (Result<Quote, Error>)-> Void) {
        request(url: url(for: .quote, queryParams: ["symbol": symbol]),
                expecting: Quote.self, completion: completion)
    }
    
    public func fetchCryptoSymbols(from platform: Platform, completion: @escaping (Result<[CryptoSymbol], Error>)-> Void) {
        request(url: url(for: .cryptoSymbol, queryParams: ["exchange": platform.rawValue]), expecting: [CryptoSymbol].self, completion: completion)
    }

    public func cryptoMarketData(for symbol: String, numberOfDays: TimeInterval = 7, completion: @escaping (Result<MarketDataResponse, Error>) -> Void) {
        
        let today = Date().addingTimeInterval(-(Constants.day))
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        
        request(
            url: url(
                for: .cryptoCandle,
                queryParams: [
                    "symbol": symbol,
                    "resolution": "5",
                    "from": "\(Int(prior.timeIntervalSince1970))",
                    "to": "\(Int(today.timeIntervalSince1970))"
                ]
            ),
            expecting: MarketDataResponse.self,
            completion: completion
        )
    }

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
        
//        print(urlString)
        
        return URL(string: urlString)
    }

    /// Perform api call
    /// - Parameters:
    ///   - url: URL to hit
    ///   - expecting: Type we expect to decode data to
    ///   - completion: Result callback
    private func request<T: Codable>( url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            // Invalid url
            completion(.failure(APIError.invalidUrl))
            return
        }
//        print(url)

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }

            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
