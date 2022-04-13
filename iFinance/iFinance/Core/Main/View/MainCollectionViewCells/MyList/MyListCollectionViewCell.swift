//
//  MyListCollectionViewCell.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//
import Combine
import UIKit

final class MyListCollectionViewCell: UICollectionViewCell {
    static let identifier = "MainCollectionViewCell"
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<Void, Never>()
    
    let myListView: MyListView
    private let viewModel: MyListViewModel
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        self.viewModel = MyListViewModel()
        self.myListView = MyListView(viewModel: viewModel)
        super.init(frame: frame)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        viewModel
            .viewModelToControllerPublisher
            .sink { s in
                switch s {
                case .reloadData:
                    self.myListView.tableView.reloadData()
                    
                case .didTap:
                    self.actionSubject.send(())
                }
            }.store(in: &cancellables)
    }
    
    private func setupUI() {
        contentView.addSubview(myListView)
        myListView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            myListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            myListView.topAnchor.constraint(equalTo: contentView.topAnchor),
            myListView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
