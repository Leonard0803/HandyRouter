//
//  ModuleJumper.swift
//  HandyRouterTests
//
//  Created by 邹贤琳 on 2023/11/17.
//

import Foundation
@testable import HandyRouter

enum ModuleJumper: String, Jumper {
    case pageA, pageB, pageC = "pageC#fragment"
    
    static var module: String {
        "module"
    }
    
    static func jump(to page: ModuleJumper, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        switch page {
        case .pageA:
            print("module pageA")
            return true
        case .pageB:
            print("module pageB")
            return true
        case pageC:
            print("module page#fragment")
            return true
        }
    }
}

enum SubModuleJumper: String, Jumper {
    
    case pageA, pageB
    
    static var module: String {
        "module/subModule"
    }
    
    static func jump(to page: SubModuleJumper, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        switch page {
        case .pageA:
            print("subModule pageA")
            return true
        case .pageB:
            print("subModule pageB")
            return true
        }
    }
}
