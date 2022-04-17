//
//  SearchViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/17.
//

import UIKit
import Combine

enum SearchViewModelListener {
    case reloadData
}

final class SearchViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SearchTransition, Never>()
    
    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
    private let listenerSubject = PassthroughSubject<SearchViewModelListener, Never>()
    
    enum Section { case main }
    
    private(set) var searchResults: [SearchResult] = []
    
    private func fetchSearchResult(query: String) {
        APICaller.shared.search(query: query) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.searchResults = response.result
                    self.listenerSubject.send(.reloadData)
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    self.searchResults = []
                    self.listenerSubject.send(.reloadData)
                }
            }
        }
    }
    
    func didSelect(at indexPath: IndexPath) {
        transitionSubject.send(.didSelect(searchResults[indexPath.row]))
    }
}

extension SearchViewModel: UISearchResultsUpdating {
    /// Update search on key tap
    /// - Parameter searchController: Ref of the search controlelr
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  return
              }
        fetchSearchResult(query: query)
    }
}
