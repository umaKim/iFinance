//
//  MainView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import UIKit.UICollectionView
import Combine

enum MainViewAction {
    
}

final class MainView: BaseView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MainViewAction, Never>()
    
    private(set) lazy var menuTabBar = MenuBarView()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MyListCollectionViewCell.self, forCellWithReuseIdentifier: MyListCollectionViewCell.identifier)
        cv.register(OpinionsCollectionViewCell.self, forCellWithReuseIdentifier: OpinionsCollectionViewCell.identifier)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        menuTabbarBind()
        
        configureMenuBar()
        configureCollectionView()
    }
   
    private func menuTabbarBind() {
        menuTabBar
            .actionPublisher
            .sink {[weak self] action in
                switch action {
                case .didTapMyList:
                    let indexPath = IndexPath(item: 0, section: 0)
                    self?.collectionView.scrollToItem(at: indexPath, at: [], animated: true)
                    
                case .didTapOpinions:
                    let indexPath = IndexPath(item: 1, section: 0)
                    self?.collectionView.scrollToItem(at: indexPath, at: [], animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView {
    private func configureMenuBar() {
        menuTabBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuTabBar)
        
        NSLayoutConstraint.activate([
            menuTabBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            menuTabBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuTabBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuTabBar.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func configureCollectionView() {
        menuTabBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalToSystemSpacingBelow: menuTabBar.bottomAnchor,
                multiplier: 0),
            collectionView.leadingAnchor.constraint(
                equalToSystemSpacingAfter: leadingAnchor,
                multiplier: 0),
            trailingAnchor.constraint(
                equalToSystemSpacingAfter: collectionView.trailingAnchor,
                multiplier: 0),
            safeAreaLayoutGuide.bottomAnchor.constraint(
                equalToSystemSpacingBelow: collectionView.bottomAnchor,
                multiplier: 0)
        ])
    }
}
