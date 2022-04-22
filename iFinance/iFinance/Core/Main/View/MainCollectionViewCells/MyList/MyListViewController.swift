//
//  MyListViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/11.
//

import Combine
import UIKit

enum DiffableDataSourceAction {
    case deleteAt(IndexPath)
}

final class TableViewDiffableDataSource: UITableViewDiffableDataSource<MyListViewModel.Section, MyWatchListModel> {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<DiffableDataSourceAction, Never>()
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var snapshot = self.snapshot()
            if let item = itemIdentifier(for: indexPath) {
                snapshot.deleteItems([item])
                apply(snapshot, animatingDifferences: true)
                actionSubject.send(.deleteAt(indexPath))
            }
        }
    }
}

final class MyListViewController: BaseViewController<MyListViewModel> {
    private typealias DataSource = TableViewDiffableDataSource
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MyListViewModel.Section, MyWatchListModel>
    
    private var dataSource: DataSource?
    
    private let contentView = MyListView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        configureTableViewDataSource()
        bind()
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.myWatchStocks)
        dataSource?.apply(snapshot, animatingDifferences: true)
        dataSource?.defaultRowAnimation = .left
    }
    
    private func setTableViewEditingMode() {
        contentView.tableView.setEditing(!contentView.tableView.isEditing,
                                         animated: true)
    }
}

//MARK: - Bind
extension MyListViewController {
    private func bind() {
        viewModel
            .listenerPublisher
            .sink { [weak self] listener in
                guard let self = self else { return }
                switch listener {
                    
                case .reloadData:
                    self.updateSections()
                    
                case .edittingMode:
                    self.setTableViewEditingMode()
                }
            }
            .store(in: &cancellables)
        
        dataSource?
            .actionPublisher
            .sink(receiveValue: {[weak self] action in
                switch action {
                case .deleteAt(let indexPath):
                    self?.viewModel.removeItem(at: indexPath)
                }
            })
            .store(in: &cancellables)
    }
}

//MARK: - UITableViewDataSource
extension MyListViewController {
    private func configureTableViewDataSource() {
        contentView.tableView.delegate = self
        dataSource = .init(tableView: contentView.tableView,
                           cellProvider: { ( tableView, indexPath, item) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchListTableViewCell.identifier, for: indexPath) as? WatchListTableViewCell else {return nil}
            cell.configure(with: item)
            return cell
        })
    }
}

//MARK: - UITableViewDelegate
extension MyListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didTap(myWatchStock: viewModel.myWatchStocks[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WatchListTableViewCell.preferredHeight
    }
}
