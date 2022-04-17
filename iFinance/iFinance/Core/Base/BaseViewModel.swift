//
//  BaseViewModel.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//
import UIKit
import Combine

protocol ViewModel {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()
    func onViewWillDisappear()
    func onViewDidDisappear()
}

class BaseViewModel: NSObject, ViewModel {
    var cancellables = Set<AnyCancellable>()

    private(set) lazy var isLoadingPublisher = isLoadingSubject.eraseToAnyPublisher()
    let isLoadingSubject = PassthroughSubject<Bool, Never>()

    private(set) lazy var errorPublisher = errorSubject.eraseToAnyPublisher()
    let errorSubject = PassthroughSubject<Error, Never>()
    
    deinit {
        debugPrint("deinit of ", String(describing: self))
    }

    func onViewDidLoad() {}
    func onViewWillAppear() {}
    func onViewDidAppear() {}
    func onViewWillDisappear() {}
    func onViewDidDisappear() {}
}
