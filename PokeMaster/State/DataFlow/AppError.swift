//
//  AppError.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/19.
//  Copyright © 2020 Willie. All rights reserved.
//

import Foundation

enum AppError: Error, Identifiable {
    
    var id: String { localizedDescription }
    
    case passwordWrong
    case exsistEmail
    case networkingFailed(Error)
}

extension AppError: LocalizedError {
    
    var localizedDescription: String {
        
        switch self {
        case .passwordWrong:
            return "邮箱或密码错误"
        case .exsistEmail:
            return "此邮箱已注册"
        case .networkingFailed(let error):
            return error.localizedDescription
        }
    }
}
