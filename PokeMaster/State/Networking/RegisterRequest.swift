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
    @EnvironmentObject var store: Store
    
    let email: String
    let password: String
    
    var publisher: AnyPublisher<User, AppError> {
        
        Future { promise in
            
            DispatchQueue
                .global()
                .asyncAfter(deadline: .now() + 1.5) {
                    
                    if self.store.appState.settings.exsistUsers?.contains(where: { $0.email == self.email }) ?? false {
                        promise(.failure(.exsistEmail))
                        
                    } else {
                        let user = User(email: self.email, favoritePokemonIDs: [])
                        promise(.success(user))
                    }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
