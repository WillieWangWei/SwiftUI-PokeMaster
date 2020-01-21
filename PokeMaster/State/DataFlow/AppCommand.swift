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

let disposeBag: DisposeBag = DisposeBag()

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        
        LoginRequest(email: email, password: password)
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
        ).add(to: disposeBag)
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

struct LoadPokemonsCommand: AppCommand {
    
    func execute(in store: Store) {
        
        LoadPokemonRequest
            .all
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(
                            .loadPokemonsDone(result: .failure(error))
                        )
                    }
            },
                receiveValue: { value in
                    store.dispatch(
                        .loadPokemonsDone(result: .success(value))
                    )
            }
        ).add(to: disposeBag)
    }
}
