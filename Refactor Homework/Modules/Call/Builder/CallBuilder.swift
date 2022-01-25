//
//  CallBuilder.swift
//  Refactor Homework
//
//  Created by Rufina on 25.01.2022.
//

import Foundation
import UIKit

final class CallBuilder {
    
    private let networkService: NetworkServiceMock
    
    init(networkService: NetworkServiceMock) {
        self.networkService = networkService
    }
    
    func build() -> UIViewController {
        let callPresenter = CallPresenter(networkService: networkService)
        let callViewController = CallViewController(presenter: callPresenter)
        callPresenter.callView = callViewController
        
        return callViewController
    }
}

