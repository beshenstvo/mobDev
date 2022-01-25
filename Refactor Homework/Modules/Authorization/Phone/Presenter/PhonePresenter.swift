//
//  PhonePresenter.swift
//  Refactor Homework
//
//  Created by Rufina on 25.01.2022.
//

import Foundation

protocol PhonePresenterProtocol {
    init(router: PhoneRouter, interactor: PhoneInteractor)
    func didAgreementClicked()
    func didCodeClicked()
    func viewDidLoadEvent()
    func willAppear()
    func willDisappear()
}

final class PhonePresenter: PhonePresenterProtocol {
    
    
    weak var phoneVC: PhoneEditViewController?
    let router: PhoneRouter
    let interactor: PhoneInteractor
    
    init(router: PhoneRouter, interactor: PhoneInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoadEvent() {
        phoneVC?.buildView()
        phoneVC?.buildConstraints()
    }
    
    func willAppear() {
        phoneVC?.willAppear()
    }
    
    func willDisappear() {
        phoneVC?.willDisappear()
    }
    
    @objc func didCodeClicked() {
        print("Code clicked")
        interactor.openCodeVC()
    }
    
    @objc func didAgreementClicked() {
        router.openAgreementVC()
    }
    
    @objc func didCodeSuccess() {
        router.openCodeVC()
    }
    
    
}

