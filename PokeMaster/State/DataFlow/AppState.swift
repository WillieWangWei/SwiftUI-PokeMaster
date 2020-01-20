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
        
        class AccountChecker {
            
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""
            
            var isEmailValid: AnyPublisher<Bool, Never> {
                
                let emailLocalValid = $email.map { $0.isValidEmailAddress }
                let canSkipRemoteVerify = $accountBehavior.map { $0 == .login }
                
                let remoteVerify = $email
                    .debounce(for: .milliseconds(500),
                              scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .flatMap { email -> AnyPublisher<Bool, Never> in
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login
                        
                        switch (validEmail, canSkip) {
                            
                        case (false, _):
                            return Just(false)
                                .eraseToAnyPublisher()
                            
                        case (true, false):
                            return EmailCheckingRequest(email: email)
                                .publisher
                                .eraseToAnyPublisher()
                            
                        case (true, true):
                            return Just(true)
                                .eraseToAnyPublisher()
                        }
                }
                
                return Publishers.CombineLatest3(emailLocalValid, canSkipRemoteVerify, remoteVerify)
                    .map { $0 && ($1 || $2) }
                    .eraseToAnyPublisher()
            }
        }
        
        var isEmailValid: Bool = false
        var loginRequesting: Bool = false
        var loginError: AppError?
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
        
        var checker = AccountChecker()
        
        @UserDefaultsBoolStorage(key: "showEnglishName")
        var showEnglishName: Bool
        
        @UserDefaultsSortingStorage(key: "sorting")
        var sorting: Sorting
        
        var showFavoriteOnly: Bool = false
    }
}
