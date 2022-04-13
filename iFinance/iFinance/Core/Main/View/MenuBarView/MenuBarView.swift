//
//  MenuBarView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//

import CombineCocoa
import Combine
import UIKit

enum MenuBarButtonAction {
    case didTapMyList
    case didTapOpinions
}

final class MenuBarButton: UIButton {
    init(title: String){
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class MenuBarView: UIView {
    private let myListButton: MenuBarButton = MenuBarButton(title: "My List")
    private let opinionsButton: MenuBarButton = MenuBarButton(title: "Opinions")
    private var buttons: [UIButton] = []
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MenuBarButtonAction, Never>()
    
    private var cancellable: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellable = .init()
        super.init(frame: .zero)
        
        backgroundColor = .black
        
        buttons = [myListButton, opinionsButton]
        configureButtons()
        configureMenuBarButtons()
    }
    
    private func configureButtons() {
        setAlpha(for: myListButton)
        
        myListButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.didTapMyList)
            }
            .store(in: &cancellable)
        
        opinionsButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.didTapOpinions)
            }
            .store(in: &cancellable)
    }
    
    private func configureMenuBarButtons() {
        
        let leadPadding: CGFloat = 16
        let buttonSpace: CGFloat = 36
        
        addSubviews(myListButton, opinionsButton)//, albumsButton )//indicator)
        
        NSLayoutConstraint.activate([
            // Buttons
            myListButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            myListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadPadding),
            
            opinionsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            opinionsButton.leadingAnchor.constraint(equalTo: myListButton.trailingAnchor, constant: buttonSpace),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Button Actions
extension MenuBarView {
    
    func selectItem(at index: Int) {
        animateIndicator(to: index)
    }
    
    func scrollIndicator(to contentOffset: CGPoint) {
        let index = Int(contentOffset.x / frame.width)
        setAlpha(for: buttons[index])
    }
    
    private func setAlpha(for button: UIButton) {
        self.myListButton.alpha = 0.5
        self.opinionsButton.alpha = 0.5
        button.alpha = 1.0
    }
    
    private func animateIndicator(to index: Int) {
        
        var button: UIButton
        
        switch index {
        case 0:
            button = myListButton
        case 1:
            button = opinionsButton
        default:
            button = myListButton
        }
        
        setAlpha(for: button)
    }
}

