//
//  AppState.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/17.
//  Copyright © 2020 Willie. All rights reserved.
//

import Foundation
import Combine

struct AppState {
    var pokemonList = PokemonList()
    var settings = Settings()
}

extension AppState {
    
    struct PokemonList {
        
        struct SelectionState {
            var expandingIndex: Int? = nil
            var panelIndex: Int? = nil
            var panelPresented = false
            
            func isExpanding(_ id: Int) -> Bool {
                expandingIndex == id
            }
        }
        
        @FileStorage(directory: .cachesDirectory, fileName: "pokemons.json")
        var pokemons: [Int: PokemonViewModel]?
        
        @FileStorage(directory: .cachesDirectory, fileName: "abilities.json")
        var abilities: [Int: AbilityViewModel]?
        
        var error: AppError?
        var loadingPokemons = false
        
        var selectionState = SelectionState()
        
        var expandingIndex: Int?
        var searchText: String = ""
        
        func displayPokemons(with settings: Settings) -> [PokemonViewModel] {
            
            func isFavorite(_ pokemon: PokemonViewModel) -> Bool {
                guard let user = settings.loginUser else { return false }
                return user.isFavoritePokemon(id: pokemon.id)
            }
            
            func containsSearchText(_ pokemon: PokemonViewModel) -> Bool {
                guard !searchText.isEmpty else {
                    return true
                }
                return pokemon.name.contains(searchText) ||
                    pokemon.nameEN.lowercased().contains(searchText.lowercased())
            }
            
            guard let pokemons = pokemons else {
                return []
            }
            
            let sortFunc: (PokemonViewModel, PokemonViewModel) -> Bool
            switch settings.sorting {
            case .id:
                sortFunc = { $0.id < $1.id }
            case .name:
                sortFunc = { $0.nameEN < $1.nameEN }
            case .color:
                sortFunc = {
                    $0.species.color.name.rawValue < $1.species.color.name.rawValue
                }
            case .favorite:
                sortFunc = { p1, p2 in
                    switch (isFavorite(p1), isFavorite(p2)) {
                    case (true, true): return p1.id < p2.id
                    case (false, false): return p1.id < p2.id
                    case (true, false): return true
                    case (false, true): return false
                    }
                }
            }
            
            var filterFuncs: [(PokemonViewModel) -> Bool] = []
            filterFuncs.append(containsSearchText)
            if settings.showFavoriteOnly {
                filterFuncs.append(isFavorite)
            }
            
            let filterFunc = filterFuncs.reduce({ _ in true}) { r, next in
                return { pokemon in
                    r(pokemon) && next(pokemon)
                }
            }
            
            return pokemons.values
                .filter(filterFunc)
                .sorted(by: sortFunc)
        }
        
        var allPokemonsByID: [PokemonViewModel] {
            guard let pokemons = pokemons?.values else { return [] }
            return pokemons.sorted { $0.id < $1.id }
        }
        
        func abilityViewModels(for pokemon: Pokemon) -> [AbilityViewModel]? {
            pokemon.abilities.map { AbilityViewModel(ability: Ability.sample(url: $0.ability.url)) }
        }
    }
    
    struct Settings {
        
        enum AccountBehavior: CaseIterable {
            case register
            case login
        }
        
        enum Sorting: Int, CaseIterable {
            case id
            case name
            case color
            case favorite
        }
        
        class AccountChecker {
            
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""
            
            var isEmailValid: AnyPublisher<Bool, Never> {
                
                let canSkip = $accountBehavior.map { $0 == .login }
                
                let emailValid = $email
                    .debounce(for: .milliseconds(500),
                              scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .flatMap { email -> AnyPublisher<Bool, Never> in
                        if email.isValidEmailAddress {
                            return EmailCheckingRequest(email: email, accountBehavior: self.accountBehavior)
                                .publisher
                        } else {
                            return Just(false)
                                .eraseToAnyPublisher()
                        }}
                    .eraseToAnyPublisher()
                
                return Publishers.CombineLatest(canSkip, emailValid)
                    .map { $0 || $1 }
                    .eraseToAnyPublisher()
            }
            
            var isPasswordValid: AnyPublisher<Bool, Never> {
                Publishers.CombineLatest3($password, $verifyPassword, $accountBehavior)
                    .map { password, verifyPassword, accountBehavior in
                        if accountBehavior == .login {
                            return true
                        } else {
                            if password.isEmpty || verifyPassword.isEmpty {
                                return false
                            } else {
                                return password == verifyPassword
                            }}
                }
                .eraseToAnyPublisher()
            }
        }
        
        var isEmailValid: Bool = false
        var isPasswordValid: Bool = false
        var accountBehaviorRequesting: Bool = false
        var loginError: AppError?
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
        
        @FileStorage(directory: .documentDirectory, fileName: "validUsers.json")
        var exsistUsers: [User]?
        
        @UserDefaultsBoolStorage(key: "showEnglishName")
        var showEnglishName: Bool
        
        @UserDefaultsSortingStorage(key: "sorting")
        var sorting: Sorting
        
        @UserDefaultsBoolStorage(key: "showFavoriteOnly")
        var showFavoriteOnly: Bool
        
        var checker = AccountChecker()
    }
}
