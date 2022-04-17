//
//  AppConfiguration.swift
//  iFinance
//
//  Created by 김윤석 on 2022/04/17.
//

import Foundation

protocol AppConfiguration {
    var bundleId: String { get }
}

final class AppConfigurationImpl: AppConfiguration {
    let bundleId: String
    
    init() {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            fatalError("no bundle info")
        }
        self.bundleId = bundleId
    }
}
