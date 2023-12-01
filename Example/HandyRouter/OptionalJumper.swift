//
//  OptionalJumper.swift
//  HandyRouter_Example
//
//  Created by 邹贤琳 on 2023/11/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import HandyRouter

enum OptionalJumper: String, Jumper {
    
    case pageA, pageB
    
    static var module: String {
        return "A/(B)/C"
    }
    
    static func jump(to page: OptionalJumper, parameters: [ParameterKey : Any]) -> Bool {
        print("\(page.rawValue) has been handled by OptionalJumper")
        return true
    }
}
