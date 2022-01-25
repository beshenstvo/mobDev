//
//  NetworkServiceMock.swift
//  Refactor Homework
//
//  Created by Kirill Varshamov on 20.11.2021.
//

import Foundation

final class NetworkServiceMock {
    
    enum NetworkError: Error {
        case incorrectCode
    }
    
    private let workQueue = DispatchQueue(label: "NetworkServiceMock\(UUID().uuidString)")
    
    // MARK: - Authorization module
    func getAgreement(complition: @escaping (Result<Agreement, Error>) -> Void) {
        workQueue.asyncAfter(deadline: .now() + 0.5) {
            complition(.success(Agreement(text: "Текст соглашения с правилами пользования сервисом")))
        }
    }
    
    func authSent(phoneNumber: String, complition: @escaping (Result<Void, Error>) -> Void) {
        workQueue.asyncAfter(deadline: .now() + 1.0) {
            complition(.success(()))
        }
    }
    
    func authSent(smsCode: String, complition: @escaping (Result<Void, NetworkError>) -> Void) {
        workQueue.asyncAfter(deadline: .now() + 1.0) {
            if smsCode == "1111" {
                complition(.failure(.incorrectCode))
            } else {
                complition(.success(()))
            }
        }
    }
    
    // MARK: - Bonus module
    func getBonusBalance(complition: @escaping (Result<BonusAmount, Error>) -> Void) {
        workQueue.asyncAfter(deadline: .now() + 0.5) {
            complition(.success(BonusAmount(bonusAmount: 500)))
        }
    }
    
    func getBonusText(complition: @escaping (Result<BonusText, Error>) -> Void) {
        workQueue.asyncAfter(deadline: .now() + 0.5) {
            complition(.success(BonusText(bonusText: "За каждую покупку вы будете получать бонусы в колличестве 10% от суммы заказа")))
        }
    }
    
    // MARK: - Call module
    func getCallNumber(complition: @escaping (Result<Call, Error>) -> Void) {
        workQueue.async {
            complition(.success(Call(number: "+7(999)999-99-99")))
        }
    }
}
