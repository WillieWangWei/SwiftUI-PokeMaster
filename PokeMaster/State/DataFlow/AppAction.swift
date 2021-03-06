//
//  AppAction.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/19.
//  Copyright © 2020 Willie. All rights reserved.
//

import Foundation

enum AppAction {
    
    case loadPokemons
    case loadPokemonsDone(result: Result<[PokemonViewModel], AppError>)
    case loadAbilities(pokemon: Pokemon)
    case loadAbilitiesDone(result: Result<[AbilityViewModel], AppError>)
    case toggleListSelection(index: Int?)
    case togglePanelPresenting(presenting: Bool)
    
    case emailValid(valid: Bool)
    case passwordValid(valid: Bool)
    case register(email: String, password: String)
    case registerDone(user: User)
    case login(email: String, password: String)
    case accountBehaviorDone(result: Result<User, AppError>)
    case resign
    case cleanCache
}
