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

    /// Symbol Label
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    /// Company Label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15)
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
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        
        setupUI()
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

    required init?(coder: NSCoder) {
        fatalError()
    }
}

//MARK: - setup UI
extension WatchListTableViewCell {
    private func setupUI() {
        configureTitleLabels()
        configurePriceLabels()
        configureChart()
    }
    
    private func configureTitleLabels() {
        let labelStackView = UIStackView(arrangedSubviews: [symbolLabel, nameLabel])
        labelStackView.distribution = .equalSpacing
        labelStackView.spacing = 6
        labelStackView.axis = .vertical
        labelStackView.frame = .init(
            x: 20,
            y:(WatchListTableViewCell.preferredHeight - frame.height) / 2,
            width: frame.width/2.2,
            height: frame.height
        )

        contentView.addSubview(labelStackView)
    }
    
    private func configurePriceLabels() {
        
        let labelStackView = UIStackView(arrangedSubviews: [priceLabel, changeLabel])
        labelStackView.distribution = .equalSpacing
        labelStackView.spacing = 6
        labelStackView.axis = .vertical
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(labelStackView)
        
        NSLayoutConstraint.activate([
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelStackView.widthAnchor.constraint(equalToConstant: frame.width/4.5)
        ])
    }
    
    private func configureChart() {
        contentView.addSubview(miniChartView)
        
        NSLayoutConstraint.activate([
            miniChartView.topAnchor.constraint(equalTo: topAnchor),
            miniChartView.bottomAnchor.constraint(equalTo: bottomAnchor),
            miniChartView.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -30),
            miniChartView.trailingAnchor.constraint(equalTo: changeLabel.leadingAnchor, constant: -5)
        ])
    }
}
