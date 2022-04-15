//
//  BaseViewController.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/15.
//

import UIKit.UIViewController
import Combine
import CombineCocoa

class BaseViewController<VM: ViewModel>: UIViewController {
    var viewModel: VM
    var cancellables = Set<AnyCancellable>()

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onViewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.onViewWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.onViewDidDisappear()
    }
    
    deinit {
        debugPrint("deinit of ", String(describing: self))
    }
}
