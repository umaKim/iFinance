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
    
    let vc: MyListView
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        let viewModel = MyListViewModel()
        self.vc = MyListView(viewModel: viewModel)
        super.init(frame: frame)
        
        backgroundColor = .red
        
        viewModel.viewModelToControllerPublisher
            .sink { s in
                switch s {
                case .reloadData:
                    self.vc.tableView.reloadData()
                    break
                    
                case .didTap:
                    self.actionSubject.send(())
                }
            }.store(in: &cancellables)
        
        contentView.addSubview(vc)
        vc.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vc.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vc.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vc.topAnchor.constraint(equalTo: contentView.topAnchor),
            vc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
