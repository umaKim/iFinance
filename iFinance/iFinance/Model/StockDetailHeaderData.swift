//
//  StockDetailHeaderData.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/17.
//

import Foundation.NSString

struct StockDetailHeaderData {
    let currentPrice: String
    let percentChange: String
    let chartViewModel: StockChartModel
    let metrics: Metrics
}
