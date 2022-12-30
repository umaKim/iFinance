//
//  FirebaseNetworkService.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/25.
//

import FirebaseDatabase
import Combine

protocol FirebaseRealTimeService {
    func fetchOpinions(completion: @escaping (PostContent) -> Void)
    func postOpinion(symbol: String, data: OpinionData)
}

final class FirebaseNetworkServiceImpl: FirebaseRealTimeService {
    
    private let database = Database.database().reference().child("specificTalk")
    
    func fetchOpinions(completion: @escaping (PostContent) -> Void) {
        database.child("generalTalk").observe(.childAdded) { snapShot in
            
            guard let dictionary = snapShot.value as? [String: Any] else { return }

            guard let idString = dictionary["id"] as? String,
                  let titleString = dictionary["title"] as? String,
                  let date = dictionary["date"] as? Double,
                  let bodyString = dictionary["body"] as? String else { return }
            
            let postContent = PostContent(id: idString,
                                          title: titleString,
                                          date: Date(timeIntervalSince1970: date),
                                          body: bodyString)
            completion(postContent)
        }
    }
    
    func postOpinion(symbol: String, data: OpinionData) {
        let value = ["id": data.id,
                     "title": data.title,
                     "date": Int(NSDate().timeIntervalSince1970),
                     "body": data.body] as [String : Any]
        
        database.child(symbol).childByAutoId().updateChildValues(value)
    }
}
