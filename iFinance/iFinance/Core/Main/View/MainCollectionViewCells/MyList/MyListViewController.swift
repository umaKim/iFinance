//
//  MyListViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/11.
//

import Combine
import UIKit


final class MyListViewController: BaseViewController<MyListViewModel> {
    private let contentView = MyListView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        contentView.tableView.dataSource = self
        contentView.tableView.delegate   = self
        
        bind()
    }
    
    private func reloadTableView() {
        contentView.tableView.reloadData()
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
                    self.reloadTableView()
                
                case .edittingMode:
                    self.setTableViewEditingMode()
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - UITableViewDataSource
extension MyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myWatchStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchListTableViewCell.identifier, for: indexPath) as? WatchListTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.myWatchStocks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeItem(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
