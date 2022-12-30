//
//  MainViewCellableAction.swift
//  iFinance
//
//  Created by 김윤석 on 2022/12/30.
//

import Combine
import UIKit

enum MainViewCellableAction {
    case didTapMyWatchList(MyWatchListModel)
    case didTapOpinion(PostContent)
}

protocol MainViewCellable {
    var actionSubject: PassthroughSubject<MainViewCellableAction, Never> { get }
    var viewModel: MainViewModel? { get set }
    var collectionView: UICollectionView? { get set }
    func run(with indexPath: IndexPath) -> UICollectionViewCell
}

final class MyListCellable: MainViewCellable {
    var actionSubject = PassthroughSubject<MainViewCellableAction, Never>()
    var viewModel: MainViewModel?
    var collectionView: UICollectionView?
    private var canecellables: Set<AnyCancellable> = []
    init() { }
    func run(with indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView?.dequeueReusableCell(
                withReuseIdentifier: MyListCollectionViewCell.identifier,
                for: indexPath
            ) as? MyListCollectionViewCell,
            let viewModel = viewModel
        else { return UICollectionViewCell() }
        cell.configure(with: viewModel.myListViewModel)
        cell.actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .didTap(let model):
                    self.actionSubject.send(.didTapMyWatchList(model))
                }
            }
            .store(in: &canecellables)
        return cell
    }
}

final class OpinionCellable: MainViewCellable {
    var actionSubject = PassthroughSubject<MainViewCellableAction, Never>()
    var viewModel: MainViewModel?
    var collectionView: UICollectionView?
    private var canecellables: Set<AnyCancellable> = []
    init() { }
    func run(with indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView?.dequeueReusableCell(
                withReuseIdentifier: OpinionsCollectionViewCell.identifier,
                for: indexPath
            ) as? OpinionsCollectionViewCell,
            let viewModel = viewModel
        else { return UICollectionViewCell() }
        cell.configure(with: viewModel.opinionsViewModel)
        cell.actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .didTap(let opinion):
                    self.actionSubject.send(.didTapOpinion(opinion))
                }
            }
            .store(in: &canecellables)
        return cell
    }
}
