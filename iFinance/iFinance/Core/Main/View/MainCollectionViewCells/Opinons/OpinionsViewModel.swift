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

final class OpinionsViewModel: BaseViewModel {
    private(set) lazy var listenerPublisher = listernSubject.eraseToAnyPublisher()
    private let listernSubject = PassthroughSubject<OpinionsViewModelListener, Never>()
    
    private(set) lazy var opinions: [PostContent] =  []
    
    private let database = Database.database().reference().child("specificTalk")
    
    override init() {
        super.init()
        fetchComments()
    }
    
    private func fetchComments() {
        let symbol = "generalTalk"
        database.child(symbol).observe(.childAdded) { snapShot in
            guard let dictionary = snapShot.value as? [String: Any] else { return }

            guard let idString = dictionary["id"] as? String,
                  let titleString = dictionary["title"] as? String,
                  let date = dictionary["date"] as? Double,
                  let bodyString = dictionary["body"] as? String else { return }
            
            let postContent = PostContent(id: idString,
                                          title: titleString,
                                          date: Date(timeIntervalSince1970: date),
                                          body: bodyString)
            
            self.opinions.append(postContent)
            
            DispatchQueue.main.async {
                self.opinions.sort { postContentA, postContentB in
                    postContentA.date > postContentB.date
                }
//                self.delegate?.updateTableView()
                self.listernSubject.send(.reloadData)
            }
        }
    }
}
