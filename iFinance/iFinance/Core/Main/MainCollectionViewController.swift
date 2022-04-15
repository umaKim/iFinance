//
//  MainCollectionViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//
import CombineCocoa
import Combine
import UIKit

class MainCollectionViewController: UIViewController {
    
    private lazy var searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: nil, action: nil)
    private lazy var writeOpinionsButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: nil, action: nil)
    
    private let contentView = MainView()
    
    private var cancellables: Set<AnyCancellable>
    
    private let viewModel: MainCollectionViewModel
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    init(viewModel: MainCollectionViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationView()

        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        
        bind()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentView.menuTabBar.scrollIndicator(to: scrollView.contentOffset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainCollectionViewController: UICollectionViewDataSource {
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
                .sink(receiveValue: { [weak self] action in
                    switch action {
                    case .didTap(let myWatchListModel):
                        self?.viewModel.stockDidTap(myWatchListModel)
                    }
                    
                })
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
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
}

//MARK: - Set up UI
extension MainCollectionViewController {
    private func setUpNavigationView() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: navigationController?.navigationBar.width ?? 0, height: navigationController?.navigationBar.height ?? 100))
        
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
    }
}
