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
    
    private var opinionsViewController: OpinionsViewController?
    private var opinionsViewModel: OpinionsViewModel?
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    //MARK: - setup
    func configure(with opinionsViewModel: OpinionsViewModel) {
        self.opinionsViewModel = opinionsViewModel
        self.opinionsViewController = OpinionsViewController(viewModel: opinionsViewModel)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
}

//MARK: - setup UI
extension OpinionsCollectionViewCell {
    private func setupUI() {
        guard let opinionsView = opinionsViewController?.view else { return }
        contentView.addSubviews(opinionsView)
        
        NSLayoutConstraint.activate([
            opinionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            opinionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            opinionsView.topAnchor.constraint(equalTo: contentView.topAnchor),
            opinionsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
