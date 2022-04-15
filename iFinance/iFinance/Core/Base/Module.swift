//
//  Module.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import Combine
import UIKit.UIViewController


protocol Transition {}

struct Module<T: Transition, V: UIViewController> {
    let viewController: V
    let transitionPublisher: AnyPublisher<T, Never>
}
