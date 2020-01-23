//
//  RegisterRequest.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/22.
//  Copyright © 2020 Willie. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct RegisterRequest {
    let email: String
    let password: String
    let store: Store
    
    var publisher: AnyPublisher<User, AppError> {
        
        Future { promise in
            
            DispatchQueue
                .global()
                .asyncAfter(deadline: .now() + 1) {
                    
                    if self.store.appState.settings.exsistUsers?.contains(where: { $0.email == self.email }) ?? false {
                        promise(.failure(.exsistEmail))
                        
                    } else {
                        let user = User(email: self.email, password: self.password, favoritePokemonIDs: [])
                        promise(.success(user))
                    }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
