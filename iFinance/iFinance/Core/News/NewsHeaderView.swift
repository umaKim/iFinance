//
//  NewsHeaderView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import CombineCocoa
import Combine
import SDWebImage
import UIKit.UITableViewHeaderFooterView

enum NewsHeaderViewAction {
    case didTapToAdd
}

/// TableView header for news
final class NewsHeaderView: UITableViewHeaderFooterView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<NewsHeaderViewAction, Never>()
    
    /// Header identifier
    static let identifier = "NewsHeaderView"
    
    /// Ideal height of header
    static let preferredHeight: CGFloat = 50
    
    private var cancellables: Set<AnyCancellable>
    
    /// ViewModel for header view
    struct ViewModel {
        let title: String
        let shouldShowAddButton: Bool
    }
    
    // MARK: - Private
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addToWatchListButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ My List", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
//
//    private let imageView: UIImageView = {
//        let iv = UIImageView()
//        iv.isUserInteractionEnabled = true
//        iv.image = UIImage(named: "tile00")
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        return iv
//    }()
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        self.cancellables = .init()
        super.init(reuseIdentifier: reuseIdentifier)
        
        bind()
        setupUI()
    }
    
    private func bind() {
        addToWatchListButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.addToWatchListButton.isHidden = true
                self?.actionSubject.send(.didTapToAdd)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        addSubviews(label, addToWatchListButton)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 14, y: 0, width: contentView.width - 28, height: contentView.height)
        
        addToWatchListButton.sizeToFit()
        addToWatchListButton.frame = CGRect( x: width - addToWatchListButton.width - 16,
                                             y: (height - addToWatchListButton.height)/2,
                                             width: addToWatchListButton.width + 8,
                                             height: addToWatchListButton.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
//        imageView.image = nil
    }

    /// Configure view
    /// - Parameter viewModel: View ViewModel
    public func configure(with viewModel: ViewModel) {
        label.text = viewModel.title
        addToWatchListButton.isHidden = !viewModel.shouldShowAddButton
    }
}
