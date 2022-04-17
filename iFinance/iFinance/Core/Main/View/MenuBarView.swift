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
    case didTapEditting
}

final class MenuBarView: UIView {
    private let myListButton: MenuBarButton = MenuBarButton(title: "My List")
    private let opinionsButton: MenuBarButton = MenuBarButton(title: "Opinions")
    private let myListSettingButton: MenuBarButton = MenuBarButton(title: "Setting")
    
    private let settingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var buttons: [UIButton] = [myListButton, opinionsButton]
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MenuBarButtonAction, Never>()
    
    private var cancellable: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellable = .init()
        super.init(frame: .zero)
        
        
//        buttons = [myListButton, opinionsButton]
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
        
        settingButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.actionSubject.send(.didTapEditting)
            }
            .store(in: &cancellable)
    }
    
    private func configureMenuBarButtons() {
        
        let horizontalPadding: CGFloat = 16
        let buttonSpace: CGFloat = 36
        
        addSubviews(myListButton, opinionsButton, settingButton)
        
        NSLayoutConstraint.activate([
            // Buttons
            myListButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            myListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            
            opinionsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            opinionsButton.leadingAnchor.constraint(equalTo: myListButton.trailingAnchor, constant: buttonSpace),
            
            settingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            settingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding)
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

