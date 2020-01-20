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
        
        enum Sorting: Int, CaseIterable {
            case id
            case name
            case color
            case favorite
        }
        
        var loginRequesting: Bool = false
        var loginError: AppError?
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
        
        var accountBehavior: AccountBehavior = .login
        var email: String = ""
        var password: String = ""
        var verifyPassword: String = ""
        
        @UserDefaultsBoolStorage(key: "showEnglishName")
        var showEnglishName: Bool
        
        @UserDefaultsSortingStorage(key: "sorting")
        var sorting: Sorting
        
        var showFavoriteOnly: Bool = false
    }
}
