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
    
    var publisher: AnyPublisher<User, AppError> {
        
        Future { promise in
            
            DispatchQueue
                .global()
                .asyncAfter(deadline: .now() + 1.5) {
                    
                    if self.password == "123" {
                        let user = User(email: self.email, favoritePokemonIDs: [])
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
