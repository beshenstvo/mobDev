//
//  PhoneBuilder.swift
//  Refactor Homework
//
//  Created by Rufina on 25.01.2022.
//

import Foundation
import UIKit

final class PhoneBuilder {
    
    private let networkService: NetworkServiceMock
    
    init(networkService: NetworkServiceMock) {
        self.networkService = networkService
    }
    
    func build() -> UIViewController {
        
        let phoneEntity = Phone()
        let phoneRouter = PhoneRouter()
        let phoneInteractor = PhoneInteractor(networkService: networkService, model: phoneEntity)
        let phonePresenter = PhonePresenter(router: phoneRouter, interactor: phoneInteractor)
        let phoneVC = PhoneEditViewController(presenter: phonePresenter)
        phoneRouter.phoneVC = phoneVC
        phonePresenter.phoneVC = phoneVC
        
        
        return phoneVC
    }
}
