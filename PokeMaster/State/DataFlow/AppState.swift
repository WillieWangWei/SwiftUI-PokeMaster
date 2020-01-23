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
    var settings = Settings()
    var pokemonList = PokemonList()
}

extension AppState {
    
    struct PokemonList {
        
        @FileStorage(directory: .cachesDirectory, fileName: "pokemons.json")
        var pokemons: [Int: PokemonViewModel]?
        
        var loadingPokemons = false
        var allPokemonsByID: [PokemonViewModel] {
            guard let pokemons = pokemons?.values else { return [] }
            return pokemons.sorted { $0.id < $1.id }
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
