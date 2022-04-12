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
    
    private let menuTabBar = MenuBarView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MyListCollectionViewCell.self, forCellWithReuseIdentifier: MyListCollectionViewCell.identifier)
        cv.register(OpinionsCollectionViewCell.self, forCellWithReuseIdentifier: OpinionsCollectionViewCell.identifier)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    private let viewModel: MainCollectionViewModel
    
    init(viewModel: MainCollectionViewModel) {
        self.viewModel = viewModel
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationView()
        configureMenuBar()
        configureCollectionView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuTabBar.scrollIndicator(to: scrollView.contentOffset)
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyListCollectionViewCell.identifier, for: indexPath) as? MyListCollectionViewCell else { return UICollectionViewCell() }
            
            cell.actionPublisher
                .sink(receiveValue: { _ in
                    self.viewModel.stockDidTap()
                })
                .store(in: &cancellables)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OpinionsCollectionViewCell.identifier, for: indexPath) as? OpinionsCollectionViewCell else { return UICollectionViewCell() }
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
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: navigationController?.navigationBar.height ?? 100))
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width-20, height: titleView.height))
        label.text = "iFinance"
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.textColor = .white
        titleView.addSubview(label)
        
        navigationItem.titleView = titleView
        
        searchButton.tintColor = .white
        writeOpinionsButton.tintColor = .white
        navigationItem.rightBarButtonItems = [writeOpinionsButton, searchButton]
        
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
    
    private func configureMenuBar() {
        menuTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuTabBar)
        
        NSLayoutConstraint.activate([
            menuTabBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTabBar.heightAnchor.constraint(equalToConstant: 50),
        ])
        
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
    
    private func configureCollectionView() {
        menuTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: menuTabBar.bottomAnchor, multiplier: 0),
            collectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: collectionView.trailingAnchor, multiplier: 0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: collectionView.bottomAnchor, multiplier: 0)
        ])
    }
}
