//
//  FirebaseRealTimeMock.swift
//  iFinanceTests
//
//  Created by 김윤석 on 2022/04/25.
//

import Foundation
@testable import iFinance

final class FirebaseRealTimeMock: FirebaseRealTimeService {
    func fetchOpinions(completion: @escaping (PostContent) -> Void) {
        completion(PostContent(id: "Test Id", title: "Test Title", date: Date(), body: "Test Body"))
    }
    
    func postOpinion(symbol: String, data: OpinionData) {
        
    }
}
