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

    var publisher: AnyPublisher<Bool, Never> {
        
        Future { promise in
            
            DispatchQueue
                .global()
                .asyncAfter(deadline: .now() + 0.5) {
                    
                if self.email.lowercased() == "123@123.com" {
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

