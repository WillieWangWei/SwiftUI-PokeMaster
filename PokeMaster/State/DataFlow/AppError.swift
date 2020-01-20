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
}

extension AppError: LocalizedError {
    
    var localizedDescription: String {
        
        switch self {
        case .passwordWrong: return "密码错误"
        }
    }
}
