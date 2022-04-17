//
//  SearchViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/17.
//

import Foundation
import UIKit

final class SearchViewController: BaseViewController<SearchViewModel> {
    private typealias DataSource = UITableViewDiffableDataSource<SearchViewModel.Section, SearchResult>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SearchViewModel.Section, SearchResult>
    
    private var dataSource: DataSource?
    
    private let contentView = SearchView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        configureSearchBar()
        configureDataSource()
        
        bind()
    }
    
    private func bind() {
        viewModel
            .listenerPublisher
            .sink {
                [weak self] listener in
                switch listener {
                case .reloadData:
                    self?.updateSections()
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = viewModel
        
        navigationItem.searchController = searchController
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.textColor = .white
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.searchResults)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController {
    private func configureDataSource() {
        contentView.tableView.delegate = self
        
        dataSource = DataSource(
            tableView: contentView.tableView,
            cellProvider: { (collectionView, indexPath, searchResult) -> UITableViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withIdentifier: SearchCell.identifier,
                    for: indexPath) as? SearchCell else { return nil }
                cell.textLabel?.text = searchResult.symbol
                cell.detailTextLabel?.text = searchResult.description
                return cell
            })
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelect(at: indexPath)
    }
}
