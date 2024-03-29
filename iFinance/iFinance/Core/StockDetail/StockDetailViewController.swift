//
//  StockDetailViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import UmaBasicAlertKit
import SafariServices
import UIKit.UITableView

final class StockDetailViewController: BaseViewController<StockDetailViewModel> {
    
    private let contentView = StockDetailView()
    
    override func loadView() {
        super.loadView()
        self.view = contentView
        configureTableView()
        bind()
    }
    
    private func configureTableView() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
}

//MARK: - Bind
extension StockDetailViewController {
    private func bind() {
        viewModel
            .listenerPublisher
            .receive(on: RunLoop.main)
            .sink {[weak self] listener in
                switch listener {
                case .reloadData:
                    self?.contentView.tableView.reloadData()
                    guard let data = self?.viewModel.headerData else { return }
                    self?.contentView.headerView.configure(with: data)
                    
                case .error:
                    self?.showDefaultAlert(title: "Error")
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - UITableViewDataSource
extension StockDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.newsStories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsStoryTableViewCell.identfier,
            for: indexPath
        ) as? NewsStoryTableViewCell else { fatalError() }
        cell.configure(with: .init(model: viewModel.newsStories[indexPath.row]))
        return cell
    }
}

//MARK: - UITableViewDelegate
extension StockDetailViewController: UITableViewDelegate, Alertable {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let header = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: NewsHeaderView.identifier
            ) as? NewsHeaderView
        else { return nil }
        header.configure(with:
                .init(
                    title: viewModel.symbol.uppercased(),
                    shouldShowAddButton: !viewModel.shouldShowAddButton
                )
        )
        header
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return }
                switch action {
                case .didTapToAdd:
                    self.viewModel.didTapAddToMyWatchList()
                    self.showActionAlert(
                        title: "Added to Watchlist",
                        with: .init(title: "Ok", style: .cancel, handler: nil)
                    )
                }
            }
            .store(in: &cancellables)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didTapNews(at: indexPath)
    }
}
