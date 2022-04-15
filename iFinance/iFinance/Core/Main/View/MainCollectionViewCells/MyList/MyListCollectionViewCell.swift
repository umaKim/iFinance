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
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MyListCollectionViewCellAction, Never>()
    
    private var myListView: MyListView?
    private var viewModel: MyListViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
//    override init(frame: CGRect) {
//        self.cancellables = .init()
//        self.viewModel = MyListViewModel()
//        self.myListView = MyListView(viewModel: viewModel)
//        super.init(frame: frame)
//
//        bind()
//        setupUI()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    func configure(with viewModel: MyListViewModel) {
        self.viewModel = viewModel
        self.myListView = MyListView(viewModel: viewModel)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        viewModel?
            .listenerPublisher
            .sink {[weak self] listen in
                switch listen {
                case .reloadData:
                    self?.myListView?.tableView.reloadData()

                case .didTap(let myWatchListModel) :
                    self?.actionSubject.send(.didTap(myWatchListModel))
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        guard let myListView = myListView else {
            return
        }

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
