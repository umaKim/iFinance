//
//  MyListCollectionViewCell.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import Combine
import UIKit

enum MyListCollectionViewCellAction {
    case didTap(MyWatchListModel)
}

final class MyListCollectionViewCell: UICollectionViewCell {
    static let identifier = "MainCollectionViewCell"
    
    private var viewModel: MyListViewModel?
    private var myListViewController: UIViewController?
    
    //MARK: - Combine
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MyListCollectionViewCellAction, Never>()
    private var cancellables: Set<AnyCancellable>
    
    //MARK: - Init
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
    }

    func configure(with viewModel: MyListViewModel) {
        self.viewModel = viewModel
        myListViewController = MyListViewController(viewModel: viewModel)
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Bind
extension MyListCollectionViewCell {
    private func bind() {
        viewModel?
            .transitionPublisher
            .sink(receiveValue: { [weak self] transition in
                switch transition {
                case .didTap(let item):
                    self?.actionSubject.send(.didTap(item))
                }
            })
            .store(in: &cancellables)
    }
}

//MARK: - Setup UI
extension MyListCollectionViewCell {
    private func setupUI() {
        guard let myListView = myListViewController?.view else { return }
        contentView.addSubviews(myListView)
        NSLayoutConstraint.activate([
            myListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            myListView.topAnchor.constraint(equalTo: contentView.topAnchor),
            myListView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
