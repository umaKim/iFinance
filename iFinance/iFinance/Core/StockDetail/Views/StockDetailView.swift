//
//  StockDetailView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import UIKit

final class StockDetailView: BaseView {
    private(set) lazy var headerView = StockDetailHeaderView()
    
    /// Primary view
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        tableView.register(NewsStoryTableViewCell.self,
                           forCellReuseIdentifier: NewsStoryTableViewCell.identfier)
        tableView.rowHeight = NewsStoryTableViewCell.preferredHeight
        return tableView
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        tableView.tableHeaderView = headerView
        
        //I used dynamic height to make the views fit with autolayout
        if let headerView = tableView.tableHeaderView {
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            headerFrame.size.height = height
            headerView.frame = headerFrame
            tableView.tableHeaderView = headerView
        }
        
        addSubviews(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
