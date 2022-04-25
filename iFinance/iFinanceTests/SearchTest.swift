//
//  SearchTest.swift
//  iFinanceTests
//
//  Created by 김윤석 on 2022/04/26.
//

import Combine
import XCTest
@testable import iFinance

class SearchTest: XCTestCase {
    
    private var viewController: SearchViewController!
    private var viewModel: SearchViewModel!
    private var view: SearchView!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        self.viewModel = SearchViewModel(networkService: NetworkMock())
        self.viewController = SearchViewController(viewModel: viewModel)
        self.view = SearchView()
        self.cancellables = .init()
        super.setUp()
        
    }
    
    func testSearch() {
        var didSelect: Bool = false
        viewModel
            .transitionPublisher
            .sink { trans in
                switch trans {
                case .didSelect(let result):
                    didSelect = true
                }
            }
            .store(in: &cancellables)
        
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.searchTextField.text = "UMA"
        viewModel.updateSearchResults(for: search)
        
    }
}
