//
//  FullScreenLayout.swift
//  iFinance
//
//  Created by 김윤석 on 2024/02/01.
//

import UIKit

protocol Layout {
    mutating func layout(of childView: UIView)
}

struct FullScreenLayout: Layout {
    private let parentView: UIView
    
    init(of parentView: UIView) {
        self.parentView = parentView
    }
    
    mutating func layout(of childView: UIView) {
        parentView.addSubviews(childView)
        NSLayoutConstraint.activate([
            childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            childView.topAnchor.constraint(equalTo: parentView.topAnchor),
            childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
        ])
    }
}
