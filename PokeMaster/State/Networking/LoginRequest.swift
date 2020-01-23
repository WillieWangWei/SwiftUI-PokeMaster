//
//  LoginRequest.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/19.
//  Copyright © 2020 Willie. All rights reserved.
//

import Foundation
import Combine

struct LoginRequest {
    let email: String
    let password: String
    let store: Store
    
    var publisher: AnyPublisher<User, AppError> {
        
        Future { promise in
            
            DispatchQueue
                .global()
                .asyncAfter(deadline: .now() + 1) {
                    
                    if let user = self.store.appState.settings.exsistUsers?
                        .first(where: { $0.email == self.email && $0.password == self.password}) {
                        promise(.success(user))
                    } else {
                        promise(.failure(.passwordWrong))
                    }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
