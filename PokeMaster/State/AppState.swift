//
//  AppState.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/17.
//  Copyright © 2020 Willie. All rights reserved.
//

struct AppState {
    var settings = Settings()
}

extension AppState {
    
    struct Settings {
        
        enum AccountBehavior: CaseIterable {
            case register
            case login
        }
        
        enum Sorting: CaseIterable {
            case id
            case name
            case color
            case favorite
        }
        
        var loginUser: User?
        
        var accountBehavior: AccountBehavior = .login
        var email: String = ""
        var password: String = ""
        var verifyPassword: String = ""
        
        var showEnglishName: Bool = true
        var sorting: Sorting = .id
        var showFavoriteOnly: Bool = false
    }
}
