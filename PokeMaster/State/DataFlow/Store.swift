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
            
        case .login(let email, let password):
            guard !newState.settings.loginRequesting else { break }
            
            newState.settings.loginRequesting = true
            appCommand = LoginAppCommand(email: email, password: password)
            
        case .accountBehaviorDone(let result):
            
            newState.settings.loginRequesting = false
            
            switch result {
                
            case .success(let user):
                newState.settings.loginUser = user
                
            case .failure(let error):
                newState.settings.loginError = error
            }
            
        case .resign:
            newState.settings.loginUser = nil
        }
        
        return (newState, appCommand)
    }
}
