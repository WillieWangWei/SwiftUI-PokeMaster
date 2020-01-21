//
//  AppAction.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/19.
//  Copyright © 2020 Willie. All rights reserved.
//

import Foundation

enum AppAction {
    case login(email: String, password: String)
    case accountBehaviorDone(result: Result<User, AppError>)
    case resign
    case emailValid(valid: Bool)
    case loadPokemons
    case loadPokemonsDone(result: Result<[PokemonViewModel], AppError>)
}
