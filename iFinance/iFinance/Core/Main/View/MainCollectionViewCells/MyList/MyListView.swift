//
//  MyListViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/11.
//

import Combine
import UIKit

final class MyListView: UIView {
    
    private(set) lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(WatchListTableViewCell.self, forCellReuseIdentifier: WatchListTableViewCell.identifier)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = .black
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let viewModel: MyListViewModel
    
    init(viewModel: MyListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myWatchStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchListTableViewCell.identifier, for: indexPath) as? WatchListTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.myWatchStocks[indexPath.row])
        return cell
    }
}

extension MyListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didTap(myWatchStocks: viewModel.myWatchStocks[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WatchListTableViewCell.preferredHeight
    }
}

/// Table cell for watch list item
final class WatchListTableViewCell: UITableViewCell {
    /// Cell id
    static let identifier = "WatchListTableViewCell"
    
    /// Delegate
//    weak var delegate: WatchListTableViewCellDelegate?
    
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
        label.textColor = .white
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
        
        backgroundColor = .black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text    = nil
        nameLabel.text      = nil
        priceLabel.text     = nil
        changeLabel.text    = nil
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
            miniChartView.trailingAnchor.constraint(equalTo: changeLabel.leadingAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}


