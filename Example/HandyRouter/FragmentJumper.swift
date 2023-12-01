//
//  FragmentJumper.swift
//  HandyRouter_Example
//
//  Created by 邹贤琳 on 2023/11/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import HandyRouter

enum FragmentJumper: String, Jumper {
    static func jump(to page: FragmentJumper, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        let controller = ModuleDetailViewController.instantiate(jumperName: String(describing: Self.self),
                                                                moduleName: Self.module,
                                                                pageName: parameters.toPage,
                                                                parameters: parameters.toString(),
                                                                url: parameters.toUrl)
        UIViewController.topMost?.navigationController?.pushViewController(controller, animated: true)
        return true
    }
    
    case pageA = "pageA#thisIsFragment"
    
    static var module: String {
        "fragmentModule"
    }
}
