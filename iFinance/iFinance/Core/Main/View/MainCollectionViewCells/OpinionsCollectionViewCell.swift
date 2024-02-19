//
//  OpinionsCollectionViewCell.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import Combine
import UIKit

enum OpinionsCollectionViewCellAction {
    case didTap(PostContent)
}

final class OpinionsCollectionViewCell: UICollectionViewCell {
    static let identifier = "Main2CollectionViewCell"

    private var opinionsViewModel: OpinionsViewModel?
    private var opinionsViewController: OpinionsViewController?
    
    //MARK: - Combine
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<OpinionsCollectionViewCellAction, Never>()
    private var cancellables: Set<AnyCancellable>
    
    //MARK: - Init
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
    }
    
    //MARK: - setup
    func configure(with opinionsViewModel: OpinionsViewModel) {
        self.opinionsViewModel = opinionsViewModel
        opinionsViewController = OpinionsViewController(viewModel: opinionsViewModel)
        bind()
        setupUI()
    }
    
    private func bind() {
        opinionsViewModel?
            .transitionPublisher
            .sink(receiveValue: { transition in
                switch transition {
                case .didTap(let opinion):
                    self.actionSubject.send(.didTap(opinion))
                }
            })
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
}

//MARK: - setup UI
extension OpinionsCollectionViewCell {
    private func setupUI() {
        guard let opinionsView = opinionsViewController?.view else { return }
        var layout = FullScreenLayout(of: contentView)
        layout.layout(of: opinionsView)
    }
}

