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
    
    
    private let opinionsViewController = OpinionsViewController(viewModel: OpinionsViewModel())
    
    private var opinionsViewModel: OpinionsViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    func configure(with opinionsViewModel: OpinionsViewModel) {
        self.opinionsViewModel = opinionsViewModel
    }
    
    private func configureUI() {
        backgroundColor = .cyan
        
        guard let opinionsView = opinionsViewController.view else { return }
        contentView.addSubview(opinionsView)
        opinionsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            opinionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            opinionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            opinionsView.topAnchor.constraint(equalTo: contentView.topAnchor),
            opinionsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
}
