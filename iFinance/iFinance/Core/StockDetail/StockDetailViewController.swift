//
//  StockDetailViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import SafariServices
import UIKit

final class StockDetailViewController: BaseViewController<StockDetailViewModel> {
    
    private let contentView = StockDetailView()
    
    override func loadView() {
        super.loadView()
        self.view = contentView
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = viewModel.myWatchListModel.companyName
        label.textColor = .white
        navigationItem.titleView = label
    }
    
    private func bind() {
        viewModel
            .listenerPublisher
            .sink {[weak self] listener in
                switch listener {
                case .reloadData:
                    DispatchQueue.main.async {
                        self?.contentView.tableView.reloadData()
                        self?.loadDataForHeaderView()
                    }
                    
                case .errror:
                    print("error")
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadDataForHeaderView() {
        self.contentView.headerView.configure(
            currentPrice: viewModel.myWatchListModel.price,
            percentChange: viewModel.myWatchListModel.changePercentage,
            chartViewModel: viewModel.myWatchListModel.chartViewModel,
            metrics: viewModel.metrics)
    }
}

extension StockDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identfier,
                                                       for: indexPath) as? NewsStoryTableViewCell else { fatalError()}
        cell.configure(with: .init(model: viewModel.stories[indexPath.row]))
        return cell
    }
}

extension StockDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView( withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else { return nil }
//        header.delegate = self
        header.configure( with: .init(title: viewModel.myWatchListModel.symbol.uppercased(),
                                      shouldShowAddButton: !PersistenceManager.shared.watchlistContains(symbol: viewModel.myWatchListModel.symbol)))
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string: viewModel.stories[indexPath.row].url) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}
