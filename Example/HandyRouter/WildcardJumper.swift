//
//  WildcardJumper.swift
//  HandyRouter_Example
//
//  Created by 邹贤琳 on 2023/11/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import HandyRouter

enum WildcardJumper: String, Jumper {
    
    static func jump(to page: WildcardJumper, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        let controller = ModuleDetailViewController.instantiate(jumperName: String(describing: Self.self), 
                                                                moduleName: Self.module, 
                                                                pageName: parameters.toPage,
                                                                parameters: parameters.toString(),
                                                                url: parameters.toUrl)
        UIViewController.topMost?.navigationController?.pushViewController(controller, animated: true)
        return true
    }
    
    case pageA, pageB
    
    static var module: String {
        "wildcardModule/*"
    }
}
