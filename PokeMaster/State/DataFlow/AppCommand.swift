//
//  AppCommand.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/19.
//  Copyright © 2020 Willie. All rights reserved.
//

import Foundation
import Combine

protocol AppCommand {
    func execute(in store: Store)
}

var token: AnyCancellable?

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        
        token = LoginRequest(email: email, password: password)
            .publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(
                            .accountBehaviorDone(result: .failure(error))
                        )
                    }
            },
                receiveValue: { user in
                    store.dispatch(
                        .accountBehaviorDone(result: .success(user))
                    )
            }
        )
    }
}

struct WriteUserAppCommand: AppCommand {
    let user: User
    
    func execute(in store: Store) {
        try? FileHelper.writeJSON(user,
                                  to: .documentDirectory,
                                  fileName: "user.json")
    }
}
