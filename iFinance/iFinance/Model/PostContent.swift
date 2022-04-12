//
//  PostContent.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import Foundation

//struct Post {
//    let companyName: String
//    let postContent: [PostContent]
//}

struct PostContent: Codable {
    let id: String
    let title: String
    let date: Date!
    let body: String
}


struct CryptoSymbol: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
}

