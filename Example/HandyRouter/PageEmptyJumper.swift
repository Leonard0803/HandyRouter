//
//  pageEmptyJumper.swift
//  HandyRouter_Example
//
//  Created by 邹贤琳 on 2023/11/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import HandyRouter

enum PageEmptyJumper: String, Jumper {
    
    case page = ""
    
    static func jump(to page: PageEmptyJumper, parameters: [ParameterKey : Any]) -> Bool {
        let controller = ModuleDetailViewController.instantiate(jumperName: String(describing: Self.self),
                                                                moduleName: Self.module,
                                                                pageName: parameters.toPage,
                                                                parameters: parameters.toString(),
                                                                url: parameters.toUrl)
        UIViewController.topMost?.navigationController?.pushViewController(controller, animated: true)
        return true
    }
    
    static var module: String {
        return "empty"
    }
}
