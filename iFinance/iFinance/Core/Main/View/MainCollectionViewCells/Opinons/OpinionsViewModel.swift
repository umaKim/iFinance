//
//  OpinionsViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/13.
//

import Combine

enum OpinionsViewModelListener {
    case reload
    case didTap
}

final class OpinionsViewModel {
    private(set) lazy var listenerPublisher = listernSubject.eraseToAnyPublisher()
    private let listernSubject = PassthroughSubject<MyListViewModelListener, Never>()
}
