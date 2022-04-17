//
//  MainCollectionViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//
import CombineCocoa
import Combine
import FloatingPanel
import UIKit

class MainViewController: BaseViewController<MainViewModel> {
    
    private lazy var searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: nil, action: nil)
    private lazy var writeOpinionsButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: nil, action: nil)
    
    private let contentView = MainView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        
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
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyListCollectionViewCell.identifier,
                for: indexPath) as? MyListCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configure(with: viewModel.myListViewModel)
            cell.actionPublisher
                .sink(receiveValue: myListHandler)
                .store(in: &cancellables)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OpinionsCollectionViewCell.identifier,
                for: indexPath) as? OpinionsCollectionViewCell else { return UICollectionViewCell() }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    private func myListHandler( action: MyListCollectionViewCellAction ) -> Void {
        switch action {
        case .didTap(let myWatchListModel):
            self.viewModel.stockDidTap(myWatchListModel)
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
}

extension MainViewController: FloatingPanelControllerDelegate  {
    /// Sets up floating news panel
    private func setUpFloatingPanel() {
        let module = NewsBuilder.build(type: .topStories)
        module
            .transitionPublisher
            .sink (receiveValue: newViewTransitionHandler)
            .store(in: &cancellables)
        
        let panel = FloatingPanelController(delegate: self)
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.set(contentViewController: module.viewController)
        panel.addPanel(toParent: self)
        let vc = module.viewController as! NewsViewController
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
        let titleView = UIView(frame: CGRect(x: 0, y: 0,
                                             width:navigationController?.navigationBar.width ?? 0,
                                             height: navigationController?.navigationBar.height ?? 25))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width, height: titleView.height))
        label.text = "iFinance"
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.textColor = .white
        titleView.addSubview(label)
        navigationItem.titleView = titleView
        
        searchButton.tintColor = .white
        writeOpinionsButton.tintColor = .white
        navigationItem.rightBarButtonItems = [writeOpinionsButton, searchButton]
    }
    
    private func bind() {
        searchButton
            .tapPublisher
            .sink { _ in
                //tell viewModel to Move to Seach View
                self.viewModel.searchButtonDidTap()
            }
            .store(in: &cancellables)
        
        writeOpinionsButton
            .tapPublisher
            .sink { _ in
                //tell viewModel to show writing vc
                self.viewModel.writingOpinionButtonDidTap()
            }
            .store(in: &cancellables)
        
        contentView
            .actionPublisher
            .sink { [weak self] action in
                switch action {
                case .didTapEditting:
                    self?.viewModel.edittingDidTap()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .listenerPublisher
            .sink {[weak self] listener in
                let indexPath = IndexPath(item: 0, section: 0)
                self?.contentView.collectionView.scrollToItem(at: indexPath, at: [], animated: true)
            }
            .store(in: &cancellables)
    }
}
