//
//  MenuBarButton.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/13.
//

import UIKit

final class MenuBarButton: UIButton {
    init(title: String){
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
