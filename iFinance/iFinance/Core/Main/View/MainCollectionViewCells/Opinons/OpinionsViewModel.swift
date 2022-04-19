//
//  OpinionsViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/13.
//

import FirebaseDatabase
import UIKit
import Combine

enum OpinionsViewModelListener {
    case reloadData
    case didTap
}

enum OpinionsViewTransition: Transition {
    case didTap(MyWatchListModel)
}

final class OpinionsViewModel: BaseViewModel {
    //MARK: - Combine
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<OpinionsViewTransition, Never>()
    
    private(set) lazy var listenerPublisher = listernSubject.eraseToAnyPublisher()
    private let listernSubject = PassthroughSubject<OpinionsViewModelListener, Never>()
    
    //MARK: - Model
    private(set) lazy var opinions: [PostContent] =  []
    
    //MARK: - Init
    override init() {
        super.init()
        fetchComments()
    }
    
    private func fetchComments() {
        let database = Database.database().reference().child("specificTalk")
        database.child("generalTalk").observe(.childAdded) {[weak self] snapShot in
            guard let dictionary = snapShot.value as? [String: Any] else { return }

            guard let idString = dictionary["id"] as? String,
                  let titleString = dictionary["title"] as? String,
                  let date = dictionary["date"] as? Double,
                  let bodyString = dictionary["body"] as? String else { return }
            
            let postContent = PostContent(id: idString,
                                          title: titleString,
                                          date: Date(timeIntervalSince1970: date),
                                          body: bodyString)
            
            self?.opinions.append(postContent)
            
            DispatchQueue.main.async {[weak self] in
                self?.opinions.sort { $0.date > $1.date }
                self?.listernSubject.send(.reloadData)
            }
        }
    }
}
