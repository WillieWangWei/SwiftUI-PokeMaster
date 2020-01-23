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

struct LoadPokemonsCommand: AppCommand {
    
    func execute(in store: Store) {
        LoadPokemonRequest
            .all
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
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

struct LoadPokemonAbilitiesCommand: AppCommand {
    let pokemon: Pokemon
    
    func execute(in store: Store) {
        LoadPokemonAbilitiesRequest(pokemon: pokemon)
            .publisher
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        store.dispatch(
                            .loadAbilitiesDone(result: .failure(error))
                        )
                    }
            },
                receiveValue: { value in
                    store.dispatch(
                        .loadAbilitiesDone(result: .success(value))
                    )
            }
        ).add(to: disposeBag)
    }
}

struct RegisterAppCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        RegisterRequest(email: email, password: password, store: store)
            .publisher
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    store.dispatch(
                        .accountBehaviorDone(result: .failure(error))
                    )
                }
            },
                  receiveValue: { user in
                    store.dispatch(
                        .registerDone(user: user)
                    )
                    store.dispatch(
                        .accountBehaviorDone(result: .success(user))
                    )
            }
        )
            .add(to: disposeBag)
    }
}

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        LoginRequest(email: email, password: password, store: store)
            .publisher
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
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
