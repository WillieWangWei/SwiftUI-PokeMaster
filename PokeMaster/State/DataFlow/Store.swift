//
//  Store.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/17.
//  Copyright © 2020 Willie. All rights reserved.
//

import Combine

class Store: ObservableObject {
    
    @Published var appState = AppState()
    var disposeBag = DisposeBag()
    
    init() {
        initData()
        setupObservers()
    }
    
    func initData() {
        if appState.settings.exsistUsers == nil {
            appState.settings.exsistUsers = [User]()
        }
    }
    
    func setupObservers() {
        
        appState.settings.checker.isEmailValid
            .sink { isValid in
                self.dispatch(.emailValid(valid: isValid))
        }.add(to: disposeBag)
        
        appState.settings.checker.isPasswordValid
            .sink { isValid in
                self.dispatch(.passwordValid(valid: isValid))
        }.add(to: disposeBag)
    }
    
    func dispatch(_ action: AppAction) {
        
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        
        let result = Store.reduce(state: appState, action: action)
        
        appState = result.0
        
        if let command = result.1 {
            
            #if DEBUG
            print("[COMMAND]: \(command)")
            #endif
            
            command.execute(in: self)
        }
    }
    
    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var newState = state
        var appCommand: AppCommand?
        
        switch action {
            
        case .loadPokemons:
            if newState.pokemonList.loadingPokemons { break }
            newState.pokemonList.loadingPokemons = true
            appCommand = LoadPokemonsCommand()
            
        case .loadPokemonsDone(let result):
            newState.pokemonList.loadingPokemons = false
            switch result {
            case .success(let models):
                newState.pokemonList.pokemons = Dictionary(uniqueKeysWithValues: models.map { ($0.id, $0) } )
            case .failure(let error):
                print(error)
            }
            
        case .accountBehaviorDone(let result):
            newState.settings.accountBehaviorRequesting = false
            switch result {
            case .success(let user):
                newState.settings.loginUser = user
            case .failure(let error):
                newState.settings.loginError = error
            }
            
        case .emailValid(let valid):
            newState.settings.isEmailValid = valid
            
        case .passwordValid(let valid):
            newState.settings.isPasswordValid = valid
            
        case .register(let email, let password):
            if newState.settings.accountBehaviorRequesting { break }
            newState.settings.accountBehaviorRequesting = true
            appCommand = RegisterAppCommand(email: email, password: password)
            
        case .registerDone(let user):
            newState.settings.exsistUsers?.append(user)
            
        case .login(let email, let password):
            if newState.settings.accountBehaviorRequesting { break }
            newState.settings.accountBehaviorRequesting = true
            appCommand = LoginAppCommand(email: email, password: password)
            
        case .resign:
            newState.settings.loginUser = nil
            
        case .cleanCache:
            newState.pokemonList.pokemons = nil
            newState.settings.exsistUsers = nil
            newState.settings.showEnglishName = false
            newState.settings.sorting = .id
            newState.settings.showFavoriteOnly = false
        }
        
        return (newState, appCommand)
    }
}

class DisposeBag {
    private var values: [AnyCancellable] = []
    func add(_ value: AnyCancellable) {
        values.append(value)
    }
}

extension AnyCancellable {
    func add(to bag: DisposeBag) {
        bag.add(self)
    }
}
