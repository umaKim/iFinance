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

enum NewsViewTransition: Transition {
    case didTapNews(NewsStory)
}

final class NewsBuilder {
    class func build(type: NewsType) -> Module<NewsViewTransition, UIViewController> {
        let vm = NewsViewModel(type: type)
        let vc = NewsViewController(viewModel: vm)
        return .init(viewController: vc, transitionPublisher: vm.transitionPublisher)
    }
}

final class NewsViewModel: NSObject {
    
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<NewsViewTransition, Never>()
    
    private(set) lazy var listenerPublisher = listenerSubject.eraseToAnyPublisher()
    private let listenerSubject = PassthroughSubject<NewsViewModelListener, Never>()
    
    //MARK: - Model
    private(set) lazy var stories = [NewsStory]()
    
    //MARK: - Delegate
//    weak var delegate: NewsViewModelDelegate?
    
    /// Instance of a type
    private let type: NewsType

    init(type: NewsType) {
        self.type = type
        super.init()
        fetchNews()
    }
}

//MARK: -

extension NewsViewModel {
    /// Fetch news models
    private func fetchNews() {
        APICaller.shared.news(for: type) { [weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let stories):
                DispatchQueue.main.async {
                    self.stories = stories
                    self.listenerSubject.send(.reloadData)
                }
            case .failure(let error):
                print(error)
                self.stories = []
                self.listenerSubject.send(.reloadData)
            }
        }
    }
    
    func didSelectNews(at indexPath: IndexPath) {
        self.transitionSubject.send(.didTapNews(stories[indexPath.row]))
    }
    
    /// Present an alert to show an error occurred when opening story
    private func presentFailedToOpenAlert() {
//        HapticsManager.shared.vibrate(for: .error)
//
//        let alert = UIAlertController(
//            title: "Unable to Open",
//            message: "We were unable to open the article.",
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        delegate?.newsDidSelectFailedToOpen(alert)
    }
}
