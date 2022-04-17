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
    
    private var cancellables: Set<AnyCancellable>
    
    private var myListViewController: MyListViewController?
    private var viewModel: MyListViewModel?
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
    }

    func configure(with viewModel: MyListViewModel) {
        self.viewModel = viewModel
        self.myListViewController = MyListViewController(viewModel: viewModel)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        viewModel?
            .listenerPublisher
            .sink {[weak self] listen in
                guard let self = self else {return }
                switch listen {
                case .reloadData:
                    self.myListViewController?.tableView.reloadData()

                case .didTap(let myWatchListModel) :
                    self.actionSubject.send(.didTap(myWatchListModel))
                    
                case .edittingMode:
                    guard let myListView = self.myListViewController else { return }
                    self.myListViewController?.tableView.setEditing(!myListView.tableView.isEditing,
                                                          animated: true)
//                    self.myListView?.tableView.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        guard let myListView = myListViewController?.view else {
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
