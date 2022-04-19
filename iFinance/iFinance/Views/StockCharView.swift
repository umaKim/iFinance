//
//  StockCharView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/13.
//
import Charts
import UIKit

/// View to show a chart
final class StockChartView: UIView {
    
    /// Chart View
    private let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(true)
        chartView.xAxis.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        return chartView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureChartView()
    }
    
    private func configureChartView() {
        addSubviews(chartView)
        
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chartView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }

    /// Reset the chart view
    func reset() {
        chartView.data = nil
    }

    /// Configure VIew
    /// - Parameter viewModel: View ViewModel
    func configure(with stockChartModel: StockChartModel) {
        var entries = [ChartDataEntry]()

        for (index, value) in stockChartModel.data.enumerated() {
            entries.append(.init(x: Double(index),y: value))
        }

        chartView.rightAxis.enabled = stockChartModel.showAxis
        chartView.legend.enabled = stockChartModel.showLegend

        let dataSet = LineChartDataSet(entries: entries, label: "7 Days")
        
        if stockChartModel.fillColor == UIColor.systemRed {
            let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                                  ChartColorTemplates.colorFromString("#ffff0000").cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            dataSet.fill = Fill(linearGradient: gradient, angle: 90)
            
        } else {
            let gradientColors = [ChartColorTemplates.colorFromString("#0000ff00").cgColor,
                                  ChartColorTemplates.colorFromString("#00ff00").cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            dataSet.fill = Fill(linearGradient: gradient, angle: 90)
        }
        
        dataSet.fillAlpha = 0.35
        dataSet.drawFilledEnabled = true
        dataSet.colors = [stockChartModel.fillColor]
        dataSet.drawFilledEnabled = true
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
