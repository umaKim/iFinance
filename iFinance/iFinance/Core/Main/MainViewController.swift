//
//  MainCollectionViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import CombineCocoa
import Combine
import FloatingPanel
import UIKit.UICollectionView

class MainViewController: BaseViewController<MainViewModel> {
    
    private let contentView = MainView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setUpFloatingPanel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpNavigationView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentView.menuTabBar.scrollIndicator(to: scrollView.contentOffset)
    }
    
    private var cells: [any MainViewCellable] = [MyListCellable(), OpinionCellable()]
}

//MARK: - Bind
extension MainViewController {
    private func bind() {
        contentView
            .actionPublisher
            .sink { [weak self] action in
                switch action {
                case .didTapEditting:
                    self?.viewModel.edittingDidTap()
                
                case .searchButtonDidTap:
                    self?.viewModel.searchButtonDidTap()
                    
                case .writingOpinionDidTap:
                    self?.viewModel.writingOpinionButtonDidTap()
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        cells.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        var cell = cells[indexPath.item]
        cell.collectionView = collectionView
        cell.viewModel = viewModel
        cell.actionSubject.sink(receiveValue: myListHandler)
            .store(in: &cancellables)
        return cell.run(with: indexPath)
    }
    
    private func myListHandler(action: MainViewCellableAction) -> Void {
        switch action {
        case .didTapMyWatchList(let myWatchListModel):
            self.viewModel.stockDidTap(myWatchListModel)
        case .didTapOpinion(let opinion):
            #warning("add functionality in the future here to enter detail page of opinion")
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: view.frame.width,
            height: collectionView.frame.height
        )
    }
}

//MARK: - FloatingPanelControllerDelegate
extension MainViewController: FloatingPanelControllerDelegate  {
    /// Sets up floating news panel
    private func setUpFloatingPanel() {
        let vm = NewsViewModel(
            networkService: NetworkServiceImpl(),
            type: .topStories
        )
        vm.transitionPublisher
            .sink(receiveValue: newViewTransitionHandler)
            .store(in: &cancellables)
        let vc = NewsViewController(viewModel: vm)
        let panel = FloatingPanelController(delegate: self)
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.set(contentViewController: vc)
        panel.addPanel(toParent: self)
        panel.track(scrollView: vc.tableView)
        let appearance = SurfaceAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.cornerRadius = 10
        panel.surfaceView.appearance = appearance
    }
    
    private func newViewTransitionHandler(transition: NewsViewTransition) -> Void {
        switch transition {
        case .didTapNews(let news):
            self.viewModel.newsDidTap(news: news)
        }
    }
}

//MARK: - Set up UI
extension MainViewController {
    private func setUpNavigationView() {
        let navigationBar = navigationController?.navigationBar
        let titleView = UIView(frame:
                                CGRect(
                                    x: 0,
                                    y: 0,
                                    width: navigationBar?.width ?? 0,
                                    height: navigationBar?.height ?? 25
                                )
        )
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width, height: titleView.height))
        label.text = "iFinance"
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.textColor = .white
        titleView.addSubview(label)
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItems = [
            contentView.writeOpinionsButton,
            contentView.searchButton
        ]
    }
}
