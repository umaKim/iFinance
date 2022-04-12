//
//  MainHomeCoordinator.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/12.
//
import Combine
import UIKit

enum MainHomeTransition: Transition {
    case moveToStockDetail
    case moveToOpinionDetail
    case moveToSearchView
    case moveToOpinionWritingView
    case moveToNewsDetail
}

final class MainHomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    
    var navigationController: UINavigationController
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController, conainter: AppContainer){
        self.navigationController = navigationController
        self.childCoordinators = []
        
    }
    
    func start() {
        let module = MainHomeBuilder.build()
        module.transitionPublisher.sink { transition in
            switch transition {
            case .moveToOpinionDetail:
                break
            case .moveToStockDetail:
                
                print("moveToStockDetail")
                break
            case .moveToSearchView:
                break
            case .moveToOpinionWritingView:
                break
            case .moveToNewsDetail:
                break
            }
        }
        .store(in: &cancellables)
        setRoot(module.viewController)
    }
}

class MainHomeBuilder {
    class func build() -> Module<MainHomeTransition, UIViewController> {
        let viewModel = MainCollectionViewModel()
        let vc = MainCollectionViewController(viewModel: viewModel)
        return .init(viewController: vc, transitionPublisher: viewModel.transitionPublisher)
    }
}

protocol Transition {}

struct Module<T: Transition, V: UIViewController> {
    let viewController: V
    let transitionPublisher: AnyPublisher<T, Never>
}
