//
//  MoudleMatchable.swift
//  HandyRouter
//
//  Created by 邹贤琳 on 2023/11/20.
//

import Foundation

public protocol ModuleMatchable {
    
    var pattern: String { set get }
    var priority: Int { set get }
    var pathComponents: [String] { set get }
    
    func response(for request: Request) -> Response
}

public protocol ModuleJumpable {
    func invokeJump(parameters: [String: Any]) -> Bool
}

public typealias ModuleRoutingResolver = ModuleMatchable & ModuleJumpable
