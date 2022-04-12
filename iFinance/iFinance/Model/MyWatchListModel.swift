//
//  MyWatchListModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import UIKit

struct MyWatchListModel {
    let symbol: String
    let companyName: String
    let price: String // formatted
    let changeColor: UIColor // red or green
    let changePercentage: String // formatted
    let chartViewModel: StockChartModel //StockChartView.ViewModel
}
