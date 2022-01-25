//
//  CallBuilder.swift
//  Refactor Homework
//
//  Created by Rufina on 25.01.2022.
//

import Foundation
import UIKit

final class AgreementBuilder {
    
    private let networkService: NetworkServiceMock
    
    init(networkService: NetworkServiceMock) {
        self.networkService = networkService
    }
    
    func build() -> UIViewController {
        let agreementPresenter = AgreementPresenter(networkService: networkService)
        let agreementViewController = AgreementViewController( presenter: agreementPresenter)
        agreementPresenter.agreementView = agreementViewController
        
        return agreementViewController
    }
}

