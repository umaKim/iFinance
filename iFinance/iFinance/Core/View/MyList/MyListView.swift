//
//  MyListViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/11.
//

import Charts
import Combine
import UIKit

class MyListView: UIView, UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myWatchStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchListTableViewCell.identifier, for: indexPath) as? WatchListTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.myWatchStocks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didTap()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WatchListTableViewCell.preferredHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum MyListViewModelToViewController {
    case reloadData
    case didTap
}

class MyListViewModel {
    private(set) lazy var viewModelToControllerPublisher = viewModelToControllerSubject.eraseToAnyPublisher()
    private let viewModelToControllerSubject = PassthroughSubject<MyListViewModelToViewController, Never>()
    
    //MARK: - Model
    
    private var watchlistChartMap: [String: [CandleStick]] = [:]
    private var watchlistQuoteMap: [String: Quote] = [:]
    
    //MARK: - ViewModel
    
    private(set) var myWatchStocks: [MyWatchListModel] = []
    
    /// Delegate
//    weak var delegate: MyListViewModelDelegate?
    
    /// Observer for watch list updates
    private var observer: NSObjectProtocol?
    
    
    //Fetch from network for stock data
    init() {
        fetchWatchlistData()
    }
    
    /// Fetch watch list models
    func fetchWatchlistData() {
        let symbols = PersistenceManager.shared.watchlist

        createPlaceholderForLoadingMyWatchStock()

        let group = DispatchGroup()

//        for symbol in symbols where watchlistQuoteMap[symbol] == nil {

        symbols.forEach { symbol in

            group.enter()
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }

                switch result {
                case .success(let data):
                    let candleSticks = data.candleSticks
                    self?.watchlistChartMap[symbol] = candleSticks
                case .failure(let error):
                    print(error)
                }
            }

            group.enter()
            APICaller.shared.quote(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }

                switch result {
                case .success(let quote):
                    self?.watchlistQuoteMap[symbol] = quote
                case .failure(let error):
                    print(error)
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.createMyWatchStocks()
//            self?.tableView.reloadData()
//            self?.delegate?.updateTableView()
            self?.viewModelToControllerSubject.send(.reloadData)
        }
    }
    
    /// Creates view models from models
    private func createMyWatchStocks() {
        var viewModels = [MyWatchListModel]()
        
        for (symbol, candleSticks) in watchlistChartMap {
            let changePercentage = watchlistQuoteMap[symbol]?.percentChange
            
            viewModels.append(
                .init(
                    symbol: symbol,
                    companyName: UserDefaults.standard.string(forKey: symbol) ?? "Company",
                    price: getLatestClosingPrice(from: candleSticks),
                    changeColor: changePercentage ?? 0.0 < 0 ? .systemRed : .systemGreen,
                    changePercentage: .percentage(from: changePercentage ?? 0.0),
                    chartViewModel: .init(
                        data: candleSticks.reversed().map { $0.close },
                        showLegend: false,
                        showAxis: false,
                        fillColor: changePercentage ?? 0.0 < 0 ? .systemRed : .systemGreen,
                        isFillColor: false
                    )
                )
            )
        }
        
        self.myWatchStocks = viewModels.sorted(by: { $0.symbol < $1.symbol })
    }
    
    private func createPlaceholderForLoadingMyWatchStock() {
        let symbols = PersistenceManager.shared.watchlist
        symbols.forEach { _ in
            myWatchStocks.append(
                .init(symbol: "Loading", companyName: "...",
                      price: "Loding", changeColor: .darkGray, changePercentage: "...",
                      chartViewModel: .init( data: [], showLegend: false, showAxis: false, fillColor: .clear, isFillColor: false)
                     )
            )
        }
//        self.myWatchStocks = myWatchStocks.sorted(by: { $0.symbol < $1.symbol })
//        self.delegate?.updateTableView()
        self.viewModelToControllerSubject.send(.reloadData)
    }
    
    /// Gets latest closing price
    /// - Parameter data: Collection of data
    /// - Returns: String
    private func getLatestClosingPrice(from data: [CandleStick]) -> String {
        guard let closingPrice = data.first?.close else { return ""}
        return .formatted(number: closingPrice)
    }
    
    func didTap() {
        viewModelToControllerSubject.send(.didTap)
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
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureChartView()
    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        chartView.frame = bounds
//    }
    
    private func configureChartView() {
        addSubview(chartView)
        
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
