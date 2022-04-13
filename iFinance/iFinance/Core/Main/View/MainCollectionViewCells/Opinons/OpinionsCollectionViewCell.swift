//
//  OpinionsCollectionViewCell.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import Combine
import UIKit

final class OpinionsCollectionViewCell: UICollectionViewCell {
    static let identifier = "Main2CollectionViewCell"
    
    let opinionsView = OpinionsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .cyan
        
        contentView.addSubview(opinionsView.view)
        opinionsView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            opinionsView.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            opinionsView.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            opinionsView.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            opinionsView.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
