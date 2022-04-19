//
//  StockDetailHeaderView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import UIKit

final class StockDetailHeaderView: BaseView {
    
    //MARK: - UI Objects
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.textAlignment = .right
        return label
    }()
    
    private let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        return label
    }()
    
    /// ChartView
    private let chartView = StockChartView()
    
    /// Segment Controller
    private let segmentController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["1D", "7D", "15D", "1M", "1Y"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    /// CollectionView
    private let metricCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MetricCollectionViewCell.self,
                                forCellWithReuseIdentifier: MetricCollectionViewCell.identifier)
        collectionView.backgroundColor = .secondarySystemBackground
        return collectionView
    }()
    
    /// Metrics viewModels
    private var metricViewModels: [MetricCollectionViewCell.ViewModel] = []
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        metricCollectionView.delegate = self
        metricCollectionView.dataSource = self
        setupUI()
    }
    
    func configure(with data: StockDetailHeaderData) {
        priceLabel.text = data.currentPrice
        priceChangeLabel.text = data.percentChange
        
        if Double(data.percentChange) ?? 0 < 0 {
            priceChangeLabel.textColor = .systemRed
        } else {
            priceChangeLabel.textColor = .systemGreen
        }
        
        let viewModel: StockChartModel = .init(data: data.chartViewModel.data,
                                              showLegend: true,
                                              showAxis: true,
                                               fillColor: data.chartViewModel.fillColor,
                                               isFillColor: data.chartViewModel.isFillColor)
        chartView.configure(with: viewModel)
        
        let metrics = data.metrics
        self.metricViewModels = [
            .init(name: "52W High", value: "\(metrics.AnnualWeekHigh ?? 0)"),
            .init(name: "52L High", value: "\(metrics.AnnualWeekLow ?? 0)"),
            .init(name: "52W Return", value: "\(metrics.AnnualWeekPriceReturnDaily ?? 0)"),
            .init(name: "Beta", value: "\(metrics.beta ?? 0)"),
            .init(name: "10D Vol.", value: "\(metrics.TenDayAverageTradingVolume ?? 0)"),
        ]
        
        metricCollectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

//MARK: - CollectionView Data Source
extension StockDetailHeaderView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return metricViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = metricViewModels[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell( withReuseIdentifier: MetricCollectionViewCell.identifier, for: indexPath) as? MetricCollectionViewCell else { fatalError() }
        cell.configure(with: viewModel)
        return cell
    }
}

//MARK: - UICollectionView Delegate Flow Layout
extension StockDetailHeaderView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2, height: 100/3)
    }
}

//MARK: - setup UI
extension StockDetailHeaderView {
    private func setupUI() {
        let labelStackView = UIStackView(arrangedSubviews: [priceLabel, priceChangeLabel])
        labelStackView.axis = .horizontal
        labelStackView.spacing = 10
        labelStackView.distribution = .equalSpacing
        
        addSubviews(labelStackView, chartView, segmentController, metricCollectionView)
        
        NSLayoutConstraint.activate([
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            labelStackView.heightAnchor.constraint(equalToConstant: 20),
            
            chartView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 10),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 250),
            
            segmentController.topAnchor.constraint(equalTo: chartView.bottomAnchor),
            segmentController.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentController.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentController.heightAnchor.constraint(equalToConstant: 30),
            
            metricCollectionView.topAnchor.constraint(equalTo: segmentController.bottomAnchor, constant: 10),
            metricCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            metricCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            metricCollectionView.heightAnchor.constraint(equalToConstant: 100),
            metricCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
