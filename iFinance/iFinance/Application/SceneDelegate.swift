//
//  SceneDelegate.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let window = window else { return }
        let coordinator = AppCoordinator(window: window, container: AppContainerImpl())
        coordinator.start()
    }
}
