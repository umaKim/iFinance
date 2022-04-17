//
//  OpinionsView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/11.
//
import FirebaseDatabase
import UIKit

final class OpinionsViewController: BaseViewController<OpinionsViewModel> {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(CommentTableViewCell.self,
                    forCellReuseIdentifier: CommentTableViewCell.identifier)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    private func bind() {
        viewModel
            .listenerPublisher
            .sink { [weak self] listener in
                switch listener {
                case .didTap:
                    print("tap")
                    
                case .reloadData:
                    self?.tableView.reloadData()
                }
            }.store(in: &cancellables)
    }
    
    private func setupUI() {
        view.addSubviews(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension OpinionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.opinions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.opinions[indexPath.row])
        return cell
    }
}

extension OpinionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
