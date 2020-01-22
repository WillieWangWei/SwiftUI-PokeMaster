//
//  EmailCheckingRequest.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/20.
//  Copyright © 2020 Willie. All rights reserved.
//

import Foundation
import Combine

struct EmailCheckingRequest {
    let email: String
    let accountBehavior: AppState.Settings.AccountBehavior
    
    var publisher: AnyPublisher<Bool, Never> {
        
        Future { promise in
            
            DispatchQueue
                .global()
                .asyncAfter(deadline: .now() + 0.5) {
                    
                    switch self.accountBehavior {
                        
                    case .register:
                        promise(.success(self.email.isValidEmailAddress))
                        
                    case .login:
                        promise(.success(self.email.isValidEmailAddress))
                    }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

