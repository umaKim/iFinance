//
//  WritingViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/18.
//

import Foundation

final class WritingViewController: BaseViewController<WritingViewModel> {
    
    private lazy var contentView = WritingView(symbol: viewModel.symbol)
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        navigationItem.leftBarButtonItems = [contentView.dismissButton]
        
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink { [weak self] action in
                switch action {
                case .saveButtonDidTap(let data):
                    self?.viewModel.save(data: data)
                    
                case .dismiss:
                    self?.viewModel.dismiss()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .listenerPublisher
            .sink { [weak self] listener in
                switch listener {
                    
                }
            }
            .store(in: &cancellables)
    }
}
