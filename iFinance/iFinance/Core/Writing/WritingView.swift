//
//  WritingView.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/18.
//

import UIKit.UIView
import CombineCocoa
import Combine

enum WritingViewAction {
    case saveButtonDidTap(OpinionData)
    case dismiss
}

final class WritingView: BaseView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<WritingViewAction, Never>()
    
    private(set) lazy var dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: nil, action: nil)
    
    private lazy var writerIdTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .tertiaryLabel
        textField.layer.cornerRadius = 8
        textField.addLeftPadding()
        textField.placeholder = "ID"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .tertiaryLabel
        textField.layer.cornerRadius = 8
        textField.addLeftPadding()
        textField.placeholder = "Title"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var bodyTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .tertiaryLabel
        textField.layer.cornerRadius = 8
        textField.addLeftPadding()
        textField.placeholder = "Share your idea or opinion"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let bodyTextView = CaptionTextView()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 35/255, green: 44/255, blue: 112/255, alpha: 1)
        button.setTitle("SAVE", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        bind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Bind
extension WritingView {
    private func bind() {
        saveButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                let data = OpinionData(id: self.writerIdTextField.text ?? "",
                                       title: self.titleTextField.text ?? "",
                                       date: Int(NSDate().timeIntervalSince1970),
                                       body: self.bodyTextView.text)
                self.actionSubject.send(.saveButtonDidTap(data))
            }
            .store(in: &cancellables)
        
        dismissButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.actionSubject.send(.dismiss)
            }
            .store(in: &cancellables)
    }
}

//MARK: - setup UI
extension WritingView {
    private func setupUI() {
        backgroundColor = .black
        addSubviews(writerIdTextField, titleTextField, bodyTextView, saveButton)
        NSLayoutConstraint.activate([
            writerIdTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            writerIdTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            writerIdTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            writerIdTextField.heightAnchor.constraint(equalToConstant: 40),
            
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleTextField.topAnchor.constraint(equalTo: writerIdTextField.bottomAnchor, constant: 10),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            bodyTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bodyTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            bodyTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bodyTextView.heightAnchor.constraint(equalToConstant: 200),
            
            saveButton.topAnchor.constraint(equalTo: bodyTextView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: frame.width / 4)
        ])
    }
}


final class CaptionTextView: UITextView {
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "  Share your idea here"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        font = UIFont.systemFont(ofSize: 16)
        
        configurePlaceHolder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeHandler), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc func textDidChangeHandler() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    private func configurePlaceHolder() {
        addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
