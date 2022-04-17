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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// ChartView
    private let chartView = StockChartView()
    
    /// Segment Controller
    private let segmentController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["1D", "7D", "15D", "1M", "1Y"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    /// Metrics viewModels
    private var metricViewModels: [MetricCollectionViewCell.ViewModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        chartView.translatesAutoresizingMaskIntoConstraints = false
        metricCollectionView.delegate = self
        metricCollectionView.dataSource = self
        configureUI()
    }
    
    private func configureUI() {
        let labelStackView = UIStackView(arrangedSubviews: [priceLabel, priceChangeLabel])
        labelStackView.axis = .horizontal
        labelStackView.spacing = 10
        labelStackView.distribution = .equalSpacing
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    /// Configure view
    /// - Parameters:
    ///   - chartViewModel: Chart view Model
    ///   - metricViewModels: Collection of metric viewModels
//    func configure(
//        currentPrice: String,
//        percentChange: String,
//        chartViewModel: StockChartModel,//StockChartView.ViewModel,
//        metrics: Metrics?
//    ) {
    
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
            .init(name: "52W High", value: "\(metrics.AnnualWeekHigh)"),
            .init(name: "52L High", value: "\(metrics.AnnualWeekLow)"),
            .init(name: "52W Return", value: "\(metrics.AnnualWeekPriceReturnDaily)"),
            .init(name: "Beta", value: "\(metrics.beta)"),
            .init(name: "10D Vol.", value: "\(metrics.TenDayAverageTradingVolume)"),
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
        //        return CGSize(width: width/2, height: 100/3)
        return CGSize(width: frame.width / 2, height: 100/3)
    }
}



/// Metric table cell
final class MetricCollectionViewCell: UICollectionViewCell {
    /// Cell id
    static let identifier = "MetricCollectionViewCell"
    
    /// Metric table cell viewModel
    struct ViewModel {
        let name: String
        let value: String
    }
    
    /// Name label
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    /// Value label
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubviews(nameLabel, valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        valueLabel.sizeToFit()
        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(x: 3, y: 0, width: nameLabel.width, height: contentView.height)
        valueLabel.frame = CGRect(x: nameLabel.right + 3, y: 0, width: valueLabel.width, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        valueLabel.text = nil
    }
    
    /// Configure view
    /// - Parameter viewModel: Views ViewModel
    func configure(with viewModel: ViewModel) {
        nameLabel.text = viewModel.name+":"
        valueLabel.text = viewModel.value
    }
}
