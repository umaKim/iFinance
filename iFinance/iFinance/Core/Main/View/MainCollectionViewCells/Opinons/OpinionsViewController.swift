//
//  OpinionsView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/11.
//
import FirebaseDatabase
import UIKit

final class OpinionsViewController: BaseViewController<OpinionsViewModel> {
    private let contentView = OpinionsView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        
        bind()
    }
}

//MARK: - Bind
extension OpinionsViewController {
    private func bind() {
        viewModel
            .listenerPublisher
            .sink { [weak self] listener in
                switch listener {
                case .didTap:
                    print("tap")
                    
                case .reloadData:
                    self?.contentView.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - UITableViewDataSource
extension OpinionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.opinions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentTableViewCell.identifier,
                for: indexPath
            ) as? CommentTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.opinions[indexPath.row])
        return cell
    }
}

//MARK: - UITableViewDelegate
extension OpinionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didTap(opinionAt: indexPath.item)
    }
}
