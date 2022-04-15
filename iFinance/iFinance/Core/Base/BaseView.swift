//
//  BaseView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import UIKit.UIView
import Combine
import CombineCocoa

class BaseView: UIView {
    var cancellables = Set<AnyCancellable>()
}
