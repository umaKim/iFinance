//
//  SearchViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/17.
//
import CombineCocoa
import Combine
import UIKit

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
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        super.init()
    }
    
    private func fetchSearchResult(query: String) {
        networkService
            .search(query: query)
            .sink { completion in
                switch completion {
                case .failure(_):
                    self.searchResults = []
                    self.listenerSubject.send(.reloadData)
                    
                case .finished:
                    print("finished")
                }
            } receiveValue: { response in
                self.searchResults = response.result
                self.listenerSubject.send(.reloadData)
            }
            .store(in: &cancellables)
        
    }
    
    func didSelect(at indexPath: IndexPath) {
        transitionSubject.send(.didSelect(searchResults[indexPath.row]))
    }
    
    private var newQuery = String()
}

extension SearchViewModel: UISearchResultsUpdating {
    /// Update search on key tap
    /// - Parameter searchController: Ref of the search controlelr
    func updateSearchResults(for searchController: UISearchController) {
        searchController
            .searchBar
            .textDidChangePublisher
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .filter(queryChecker)
            .sink {[weak self] query in
                self?.fetchSearchResult(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func queryChecker(query: String) -> Bool {
        if query != newQuery {
            newQuery = query
            return true
        }
        return false
    }
}
