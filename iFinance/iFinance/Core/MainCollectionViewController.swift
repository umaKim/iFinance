//
//  MainCollectionViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import UIKit

class MenuTabBar: UIView {
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .systemBrown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainCollectionViewController: UIViewController, UICollectionViewDataSource {

    private let menuTabBar = MenuTabBar()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        cv.register(Main2CollectionViewCell.self, forCellWithReuseIdentifier: Main2CollectionViewCell.identifier)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private let viewModel: MainCollectionViewModel
    
    init(viewModel: MainCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenuBar()
        configureCollectionView()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Main2CollectionViewCell.identifier, for: indexPath) as? Main2CollectionViewCell else {return UICollectionViewCell()}
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
}

class MainCollectionViewCell: UICollectionViewCell {
    static let identifier = "MainCollectionViewCell"
    
    let vc: MyListViewController
    
    override init(frame: CGRect) {
        self.vc = MyListViewController(viewModel: <#T##MyListViewModel#>)
        super.init(frame: frame)
        
        backgroundColor = .red
        
        contentView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vc.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Main2CollectionViewCell: UICollectionViewCell {
    static let identifier = "Main2CollectionViewCell"
    
    let vc = OpinionsViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .cyan
        
        contentView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vc.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
