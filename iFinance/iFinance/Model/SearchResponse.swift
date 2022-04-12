//
//  SearchResponse.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import Foundation

/// API response for search
struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}

/// A single search result
struct SearchResult: Codable, Hashable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type:  String
}
