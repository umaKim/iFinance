//
//  NewsViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/17.
//

import UIKit.UIViewController
import Combine

/// Controller to show news
final class NewsViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Primary news view
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        // Rgister cell, header
        table.register(NewsStoryTableViewCell.self,
                       forCellReuseIdentifier: NewsStoryTableViewCell.identfier)
        table.register(NewsHeaderView.self,
                       forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        table.backgroundColor = .clear
        return table
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    //MARK: - ViewModel
    
    private let viewModel: NewsViewModel
    
    // MARK: - Init
    
    init(viewModel: NewsViewModel) {
        self.cancellables = .init()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel
            .listenerPublisher
            .sink { [weak self] listener in
                switch listener {
                case .reloadData:
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        //        viewModel.delegate = self
    }
    
    // MARK: - Private
    
    /// Sets up tableView
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        //        tableView.delegate = viewModel
        //        tableView.dataSource = viewModel
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identfier, for: indexPath) as? NewsStoryTableViewCell else { return UITableViewCell()}
        cell.configure(with: .init(model: viewModel.stories[indexPath.row]))
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NewsHeaderView.identifier
        ) as? NewsHeaderView else { return nil }
        header.configure(with: .init( title: "Top News", shouldShowAddButton: false))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        viewModel.didSelectNews(at: indexPath)
    }
}

//extension NewsViewController: NewsViewModelDelegate {
//    func newsDidSelectToOpen(_ url: URL) {
//        let vc = SFSafariViewController(url: url)
//        present(vc, animated: true)
//    }
//
//    func newsDidSelectFailedToOpen(_ alertControl: UIAlertController) {
//        present(alertControl, animated: true, completion: nil)
//    }
//
//    func tableViewUpdated() {
//        tableView.reloadData()
//    }
//}
