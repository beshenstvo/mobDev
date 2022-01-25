//
//  CallBuilder.swift
//  Refactor Homework
//
//  Created by Rufina on 25.01.2022.
//

import Foundation
import UIKit

final class BonusBuilder {
    
    private let networkService: NetworkServiceMock
    
    init(networkService: NetworkServiceMock) {
        self.networkService = networkService
    }
    
    func build() -> UIViewController {
        let bonusPresenter = BonusPresenter(networkService: networkService)
        let bonusViewController = BonusViewController(presenter: bonusPresenter)
        bonusPresenter.bonusView = bonusViewController
        
        return bonusViewController
    }
}

