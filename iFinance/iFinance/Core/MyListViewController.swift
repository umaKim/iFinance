//
//  MyListViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/11.
//

import Combine
import UIKit

class MyListViewController: UITableViewController {
    
    private let viewModel: MyListViewModel
    
    init(viewModel: MyListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .green
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum MyListViewTransition: Transition {
    
}

//class MyListBuilder {
//    class func build() -> Module<MyListViewTransition, UIViewController> {
//        let viewModel = MyListViewModel()
//        let viewController = MyListViewController(viewModel: viewModel)
//        return .init(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
//    }
//}

class MyListViewModel {
//    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
//    private let transitionSubject = PassthroughSubject<MyListViewTransition, Never>()
    
    private(set) lazy var didTapPublisher = didTapSubject.eraseToAnyPublisher()
    private let didTapSubject = PassthroughSubject<Void, Never>()
    
    func didTap(){
        didTapSubject.send(())
    }
}
