//
//  WatchListTableViewCell.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/18.
//

import UIKit.UITableViewCell

/// Table cell for watch list item
final class WatchListTableViewCell: UITableViewCell {
    /// Cell id
    static let identifier = "WatchListTableViewCell"
    
    /// Ideal height of cell
    static let preferredHeight: CGFloat = 60
    
    /// Watchlist table cell viewModel
//    struct ViewModel {
//        let symbol: String
//        let companyName: String
//        let price: String // formatted
//        let changeColor: UIColor // red or green
//        let changePercentage: String // formatted
//        let chartViewModel: StockChartView.ViewModel
//    }
    
    /// Symbol Label
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Company Label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Price Label
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Change Label
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.textAlignment = .right
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Chart
    private let miniChartView: StockChartView = {
        let chart = StockChartView()
        chart.isUserInteractionEnabled = false
        chart.clipsToBounds = true
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubviews(symbolLabel, nameLabel, miniChartView, priceLabel, changeLabel)
        configureTitleLabels()
        configurePriceLabels()
        configureChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        miniChartView.reset()
    }
    
    /// Configure view
    /// - Parameter viewModel: View ViewModel
    public func configure(with viewModel: MyWatchListModel) {
        symbolLabel.text = viewModel.symbol
        nameLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor
        miniChartView.configure(with: viewModel.chartViewModel)
    }
    
    private func configureTitleLabels() {
        
        let labelStackView = UIStackView(arrangedSubviews: [symbolLabel, nameLabel])
        labelStackView.distribution = .equalSpacing
        labelStackView.spacing = 6
        labelStackView.axis = .vertical
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(labelStackView)
        
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            labelStackView.widthAnchor.constraint(equalToConstant: frame.width/2.2),
            labelStackView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -30),
        ])
    }
    
    private func configurePriceLabels() {
        
        let labelStackView = UIStackView(arrangedSubviews: [priceLabel, changeLabel])
        labelStackView.distribution = .equalSpacing
        labelStackView.spacing = 6
        labelStackView.axis = .vertical
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(labelStackView)
        
        NSLayoutConstraint.activate([
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelStackView.widthAnchor.constraint(equalToConstant: frame.width/4.5)
        ])
    }
    
    private func configureChart() {
        addSubview(miniChartView)
        
        NSLayoutConstraint.activate([
            miniChartView.topAnchor.constraint(equalTo: topAnchor),
            miniChartView.bottomAnchor.constraint(equalTo: bottomAnchor),
            miniChartView.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -30),
//            miniChartView.widthAnchor.constraint(equalToConstant: frame.width / 2.5)
            miniChartView.trailingAnchor.constraint(equalTo: changeLabel.leadingAnchor, constant: -5)
        ])
    }
}
