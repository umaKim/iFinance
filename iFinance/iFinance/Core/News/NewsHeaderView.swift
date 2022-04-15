//
//  NewsHeaderView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//
import SDWebImage
import UIKit

/// Delegate to notify of header evnets
protocol NewsHeaderViewDelegate: AnyObject {
    /// Notify user tapped header button
    /// - Parameter headerView: Ref of header view
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView)
}

/// TableView header for news
final class NewsHeaderView: UITableViewHeaderFooterView {
    /// Header identifier
    static let identifier = "NewsHeaderView"

    /// Ideal height of header
    static let preferredHeight: CGFloat = 50
    
    /// Delegate instance for evnets
    weak var delegate: NewsHeaderViewDelegate?

    /// ViewModel for header view
    struct ViewModel {
        let title: String
        let shouldShowAddButton: Bool
    }

    // MARK: - Private

    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
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
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(named: "tile00")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // MARK: - Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemBackground
        addSubviews(label, addToWatchListButton)//, imageView)
        addToWatchListButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapButton)))
        
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
    }

    /// Handle button tap
    @objc private func didTapButton() {
        // Call delegate
        addToWatchListButton.isHidden = true
//
//        imageView.animationImages = spriteImages
//        imageView.animationDuration = 0.6
//        imageView.animationRepeatCount = 1
//        imageView.startAnimating()
//        imageView.image = imageView.animationImages?.last
        delegate?.newsHeaderViewDidTapAddButton(self)
    }

    /// Configure view
    /// - Parameter viewModel: View ViewModel
    public func configure(with viewModel: ViewModel) {
        label.text = viewModel.title
        addToWatchListButton.isHidden = !viewModel.shouldShowAddButton
    }
}
