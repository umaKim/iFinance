//
//  NewsViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/17.
//

import Combine
import Foundation
import UIKit

enum NewsViewModelListener {
    case reloadData
}

final class NewsViewModel: BaseViewModel {
    
    //MARK: - Combine
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<NewsViewTransition, Never>()
    
    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
    private let listenerSubject = PassthroughSubject<NewsViewModelListener, Never>()
    
    //MARK: - Model
    private(set) lazy var stories = [NewsStory]()
    
    private let networkService: NetworkService
    /// Instance of a type
    private let type: NewsType
    
    //MARK: - Init
    init(
        networkService: NetworkService,
        type: NewsType
    ) {
        self.networkService = networkService
        self.type = type
        super.init()
        fetchNews()
    }
}

extension NewsViewModel {
    /// Fetch news models
    private func fetchNews() {
        networkService
            .news(for: type)
            .sink {[weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(_):
                    self.stories = []
                    
                case .finished:
                    print("finished")
                }
            } receiveValue: {[weak self] newsStories in
                guard let self = self else { return }
                self.stories = newsStories
                self.listenerSubject.send(.reloadData)
            }
            .store(in: &cancellables)
    }
    
    func didSelectNews(at indexPath: IndexPath) {
        self.transitionSubject.send(.didTapNews(stories[indexPath.row]))
    }
}
