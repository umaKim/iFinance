//
//  OpinionsView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/19.
//

import UIKit.UITableView

final class OpinionsView: BaseView {
    //MARK: - UI Object
    private(set) lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(CommentTableViewCell.self,
                    forCellReuseIdentifier: CommentTableViewCell.identifier)
        return tv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - setup UI
extension OpinionsView {
    private func setupUI() {
        addSubviews(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
