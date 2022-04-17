//
//  SearchView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/17.
//

import Foundation
import UIKit

final class SearchView: BaseView {
    private(set) lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        tableView.rowHeight = SearchCell.prefferedHeight
        
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
